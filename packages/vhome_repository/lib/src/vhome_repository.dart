import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vhome_repository/src/auth_state.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

export 'auth_state.dart';

class AuthStateController {
  final StreamController<AuthState> _stream = StreamController<AuthState>();

  Sink<AuthState> get _input => _stream.sink;
  Stream<AuthState> get output => _stream.stream;

  AuthState _currentValue = const AuthState.unauthenticated();
  AuthState get current => _currentValue;
  
  Stream<AuthState> get authStream async* {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final authStateStr = prefs.getString("authState");

    if (authStateStr == null) {
      yield const AuthState.unauthenticated();
    } else {
      _currentValue = AuthState.fromJson(jsonDecode(authStateStr)); 
      yield _currentValue;
    }

    yield* output;
  }

  String get token {
    assert(_currentValue.status.hasToken);
    assert(_currentValue.data != null);

    return _currentValue.data!.token;
  }

  Future<void> update(AuthState value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _currentValue = value.status != AuthStatus.pending
      ? value
      : _currentValue;

    prefs.setString("authState", jsonEncode(value));

    _input.add(value);
  }

  void close() {
    _stream.close();
  }
}

class VhomeRepository {
  VhomeRepository({
    required DeviceApi deviceApi,
    required MeasurementApi measurementApi,
    required GroupApi groupApi,
    required TasksetApi tasksetApi,
    required TaskApi taskApi,
    required AuthApi authApi,
    required UserApi userApi,
    this.display = false,
  }) : _deviceApi = deviceApi,
       _measurementApi = measurementApi,
       _groupApi = groupApi,
       _tasksetApi = tasksetApi,
       _taskApi = taskApi,
       _authApi = authApi,
       _userApi = userApi;

  final DeviceApi _deviceApi;
  final MeasurementApi _measurementApi;
  final GroupApi _groupApi;
  final TasksetApi _tasksetApi;
  final TaskApi _taskApi;
  final AuthApi _authApi;
  final UserApi _userApi;
  final bool display;

  final _authStateController = AuthStateController();

  // Auth
  Stream<AuthState> get authStream => _authStateController.authStream;

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

  Future<void> loginDisplay(UserLogin data) async {
    _authStateController.update(AuthState.groupSelected(data));
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

  Stream<Task> getTask(int taskId)
    => _taskApi.getTask(_authStateController.token, taskId);
  Stream<List<Task>> getTasks(int tasksetId)
    => _taskApi.getTasks(_authStateController.token, tasksetId);
  Stream<List<Task>> getTasksRecentChanges(int tasksetId, int limit)
    => _taskApi.getTasksRecentChanges(_authStateController.token, tasksetId, limit);
  Future<void> toggleTaskCompletion(Task task, bool value)
    => _taskApi.changeCompleted(_authStateController.token, task, value);
  Future<void> changeAssign(int task, int user, bool value)
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
  Stream<Device> getDevice(int deviceId)
    => _deviceApi.getDevice(_authStateController.token, deviceId);
  Future<DeviceToken> addDevice(String name, DeviceType type)
    => _deviceApi.addDevice(_authStateController.token, name, type);
  Future<void> editDevice(int deviceId, String name)
    => _deviceApi.edit(_authStateController.token, deviceId, name);
  Future<void> deleteDevice(int deviceId)
    => _deviceApi.delete(_authStateController.token, deviceId);

  // Measurements
  Future<List<Measurement>> getMeasurements(int deviceId, MeasurementTimeRange timeRange)
    => _measurementApi.getMeasurements(_authStateController.token, deviceId, timeRange);

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

  // Pairing

  String? _pairingCode;

  Stream<UserLogin?> get pairingStream
    => Stream.periodic(
      const Duration(seconds: 5),
      (_) => _pairingCode != null ? getDisplayToken(_pairingCode!) : null
    ).asyncMap((r) async => await r);

  Future<String> getPairingCode() async {
    final pairingCode = await _authApi.getPairingCode();
    _pairingCode = pairingCode;
    return pairingCode;
  }
  
  Future<UserLogin?> getDisplayToken(String pairingCode)
    => _authApi.getDisplayToken(pairingCode);

  Future<void> addDisplay(String pairingCode)
    => _authApi.addDisplay(_authStateController.token, pairingCode);
  
  // refresh

  void refreshDevices()
    => _deviceApi.refreshDevices();

  void refreshTasks()
    => _taskApi.refreshTasks();

  void refreshTasksets() {
    _tasksetApi.refreshTasksets();
    _taskApi.refreshTasks();
  }

  void refreshUsers()
    => _userApi.refreshUsers();

  // dispose
  void dispose() => _authStateController.close();
}
