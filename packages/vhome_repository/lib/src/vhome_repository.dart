import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:vhome_repository/src/auth_state.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

export 'auth_state.dart';

class AuthStateController {
  final StreamController<AuthState> _stream = StreamController<AuthState>();

  Sink<AuthState> get _input => _stream.sink;
  Stream<AuthState> get output => _stream.stream;

  AuthState _currentValue = const AuthState.unauthenticated();
  AuthState get current => _currentValue;

  String get token {
    assert(_currentValue.status.hasToken);
    assert(_currentValue.data != null);

    return _currentValue.data!.token;
  }

  void update(AuthState value) {
    _currentValue = value.status != AuthStatus.pending
      ? value
      : _currentValue;

    _input.add(value);
  }

  void close() {
    _stream.close();
  }
}

class VhomeRepository {
  VhomeRepository({
    required DeviceApi deviceApi,
    required GroupApi groupApi,
    required TasksetApi tasksetApi,
    required TaskApi taskApi,
    required AuthApi authApi,
    required UserApi userApi,
  }) : _deviceApi = deviceApi,
       _groupApi = groupApi,
       _tasksetApi = tasksetApi,
       _taskApi = taskApi,
       _authApi = authApi,
       _userApi = userApi;

  final DeviceApi _deviceApi;
  final GroupApi _groupApi;
  final TasksetApi _tasksetApi;
  final TaskApi _taskApi;
  final AuthApi _authApi;
  final UserApi _userApi;

  final _authStateController = AuthStateController();

  // Auth
  Stream<AuthState> get authStream async* {
    yield const AuthState.unauthenticated();
    yield* _authStateController.output;
  }

  AuthState get currentAuthStatus => _authStateController.current;
  
  Future<bool> loginUser(String username, String password) async {
    _authStateController.update(const AuthState.pending());
    final data = await _authApi.getAuthToken(username, password);
    _authStateController.update(
      data != null 
        ? AuthState.groupUnselected(data)
        : const AuthState.unauthenticated()
    );

    return data != null;
  }

  Future<void> registerUser(String username, String password, Uint8List? picture) async {
    await _userApi.registerUser(username, password);

    final data = await _authApi.getAuthToken(username, password);
    if (data == null) {
      throw Exception("Could not verify user log in");
    }

    if (picture != null) {
      await _userApi.uploadUserPicture(data.token, picture);
    }

    await _authApi.logout(data.token);
  }

  Future<void> selectGroup(int groupId) async {
    _authStateController.update(const AuthState.pending());
    final data = await _authApi.selectGroup(_authStateController.token, groupId);
    _authStateController.update(
      data != null 
        ? AuthState.groupSelected(data)
        : const AuthState.unauthenticated()
    );
  }

  Future<void> unselectGroup() async {
    _authStateController.update(const AuthState.pending());
    final data = await _authApi.unselectGroup(_authStateController.token);
    _authStateController.update(
      data != null
        ? AuthState.groupUnselected(data)
        : const AuthState.unauthenticated()
    );
  }

  Future<void> leaveGroup() async {
    _authStateController.update(const AuthState.pending());
    final data = await _authApi.leaveGroup(_authStateController.token);
    _authStateController.update(
      data != null
        ? AuthState.groupUnselected(data)
        : const AuthState.unauthenticated()
    );
  }

  Future<void> addGroup(String name) async {
    _authStateController.update(const AuthState.pending());
    final data = await _authApi.addGroup(_authStateController.token, name);
    _authStateController.update(
      data != null
        ? AuthState.groupSelected(data)
        : const AuthState.unauthenticated()
    );
  }

  Future<void> acceptInvitation(String invitation) async {
    _authStateController.update(const AuthState.pending());
    final data = await _authApi.acceptInvitation(_authStateController.token, invitation);
    _authStateController.update(
      data != null
        ? AuthState.groupSelected(data)
        : const AuthState.unauthenticated()
    );
  }

  Future<void> logout() async {
    _authStateController.update(const AuthState.pending());
    await _authApi.logout(_authStateController.token);
    _authStateController.update(const AuthState.unauthenticated());
  }

  // Tasksets

  Stream<List<Taskset>> getTasksets()
    => _tasksetApi.getTasksets(_authStateController.token);
  Future<void> addTaskset(String name)
    => _tasksetApi.addTaskset(_authStateController.token, name);
  Future<void> deleteTaskset(Taskset taskset)
    => _tasksetApi.deleteTaskset(_authStateController.token, taskset);

  // Tasks

  Stream<List<Task>> getTasks(int tasksetId)
    => _taskApi.getTasks(_authStateController.token, tasksetId);
  Future<void> toggleTaskCompletion(Task task, bool value)
    => _taskApi.changeCompleted(_authStateController.token, task, value);
  Future<void> changeAssign(Task task, User user, bool value)
    => _taskApi.changeAssign(_authStateController.token, task, user, value);
  Future<void> addTask(Task task)
    => _taskApi.add(_authStateController.token, task.tasksetId, task.title, task.content);
  Future<void> editTask(Task task)
    => _taskApi.edit(_authStateController.token, task);
  Future<void> deleteTask(Task task)
    => _taskApi.delete(_authStateController.token, task);

  // Devices

  Stream<List<Device>> getDevices()
    => _deviceApi.getDevices(_authStateController.token);
  Future<DeviceToken> addDevice(String name, DeviceType type)
    => _deviceApi.addDevice(_authStateController.token, name, type);

  // Groups

  Stream<List<Group>> getGroups()
    => _groupApi.getGroups(_authStateController.token);
  Future<String> generateInvitationCode()
    => _groupApi.generateInvitationCode(_authStateController.token);

  // User

  Stream<List<User>> getUsers()
    => _userApi.getUsers(_authStateController.token);
  Future<void> uploadProfilePicture(Uint8List data)
    => _userApi.uploadUserPicture(_authStateController.token, data);
  void refreshUsers()
    => _userApi.refreshUsers();
  

  // dispose

  void dispose() => _authStateController.close();
}
