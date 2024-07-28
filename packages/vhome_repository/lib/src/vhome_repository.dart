import 'dart:async';

import 'package:vhome_web_api/vhome_web_api.dart';

enum AuthState {
  pending,
  unauthenticated,
  groupUnselected,
  groupSelected,
}

class VhomeRepository {
  VhomeRepository({
    required DeviceApi deviceApi,
    required GroupApi groupApi,
    required TasksetApi tasksetApi,
    required TaskApi taskApi,
    required UserApi userApi,
  }) : _deviceApi = deviceApi,
       _groupApi = groupApi,
       _tasksetApi = tasksetApi,
       _taskApi = taskApi,
       _userApi = userApi {
        _authStateController.add(AuthState.unauthenticated);
       }

  final DeviceApi _deviceApi;
  final GroupApi _groupApi;
  final TasksetApi _tasksetApi;
  final TaskApi _taskApi;
  final UserApi _userApi;

  final _authStateController = StreamController<AuthState>();
  User? _user;

  // Auth

  Stream<AuthState> get authState$ => _authStateController.stream;

  Stream<AuthState> get status async* {
    yield AuthState.unauthenticated;
    yield* _authStateController.stream;
  }

  Future<User?> tryGetUser() async => _user;
  
  Future<bool> loginUser(String username, String password) async {
    _authStateController.add(AuthState.pending);
    _user = await _userApi.getAuthToken(username, password);
    _authStateController.add(
      _user != null ?
        AuthState.groupUnselected :
        AuthState.unauthenticated
    );

    return _user != null;
  }

  Future<void> selectGroup(int groupId) async {
    _authStateController.add(AuthState.pending);
    _user = await _userApi.selectGroup(_user!.token, groupId);
    _authStateController.add(
      (_user != null && _user!.isGroupSelected) ?
        AuthState.groupSelected :
        AuthState.unauthenticated
    );
  }

  Future<void> unselectGroup() async {
    _authStateController.add(AuthState.pending);
    _user = await _userApi.unselectGroup(_user!.token);
    _authStateController.add(
      _user != null ?
        AuthState.groupUnselected :
        AuthState.unauthenticated
    );
  }


  Future<void> logout() async {
    _authStateController.add(AuthState.pending);
    _user = await _userApi.logout(_user!.token);
    _authStateController.add(AuthState.unauthenticated);
  }

  // Tasksets

  Stream<void> get tasksetsOutdated => _tasksetApi.tasksetOutdated();

  Stream<List<Taskset>> getTasksets() => _tasksetApi.getTasksets(_user!.token);
  Future<void> addTaskset(String name) => _tasksetApi.addTaskset(_user!.token, name);
  Future<void> deleteTaskset(Taskset taskset) => _tasksetApi.deleteTaskset(_user!.token, taskset);

  // Tasks

  Stream<List<Task>> getTasks(int tasksetId) => _taskApi.getTasks(_user!.token, tasksetId);
  Future<void> toggleTaskCompletion(Task task, bool value) => _taskApi.changeCompleted(_user!.token, task, value);
  Future<void> addTask(Task task) => _taskApi.add(_user!.token, task.tasksetId, task.title, task.content);
  Future<void> deleteTask(Task task) => _taskApi.delete(_user!.token, task);

  // Devices

  Stream<List<Device>> getDevices() => _deviceApi.getDevices(_user!.token);
  Future<DeviceToken> addDevice(String name, DeviceType type) => _deviceApi.addDevice(_user!.token, name, type);

  // Groups

  Stream<List<Group>> getGroups() => _groupApi.getGroups(_user!.token);

  void dispose() => _authStateController.close();
}
