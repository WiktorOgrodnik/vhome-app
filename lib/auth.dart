import 'dart:async';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:vhome_frontend/service/group.dart';
import 'package:vhome_frontend/service/user.dart';

enum AuthState {
  pending,
  unauthenticated,
  groupUnselected,
  groupSelected,
}

class Auth {
  static final Auth _instance = Auth._internal();
  factory Auth() => _instance;
  Auth._internal() {
    _authStateController.add(AuthState.unauthenticated);
    _checkAuthStatus();
  }

  final _authStateController = StreamController<AuthState>.broadcast();

  Stream<AuthState> get authState$ => _authStateController.stream;

  void _checkAuthStatus() async {
    await Future.delayed(Duration(milliseconds: 50));
    _authStateController.add(AuthState.unauthenticated);
  }

  Future<bool> login(String username, String password) async {
    _authStateController.add(AuthState.pending);
    var user = await UserService().getAuthToken(username, password);
    if (user == null) {
      _authStateController.add(AuthState.unauthenticated);
      return false;
    }

    await SessionManager().set("user.token", user.token);

    _authStateController.add(AuthState.groupUnselected);
    return true;
  }

  Future<void> selectGroup(int groupId) async {
    _authStateController.add(AuthState.pending);
    var user = await UserService().selectGroup(groupId);
    if (user == null) {
      _authStateController.add(AuthState.groupUnselected);
      return;
    }
    
    await SessionManager().set("user.token", user.token);

    _authStateController.add(AuthState.groupSelected);
  }

  Future<void> unselectGroup() async {
    _authStateController.add(AuthState.pending);
    var user = await UserService().unselectGroup();
    if (user == null) {
      _authStateController.add(AuthState.unauthenticated);
      return;
    }
    
    await SessionManager().set("user.token", user.token);

    _authStateController.add(AuthState.groupUnselected);
  }


  Future<void> logout() async {
    _authStateController.add(AuthState.pending);
    await UserService().logout();
    await SessionManager().remove("user.token");
    _authStateController.add(AuthState.unauthenticated);
  }

  void dispose() {
    _authStateController.close();
  }
}
