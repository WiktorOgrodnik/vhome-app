import 'dart:async';

import 'package:vhome_frontend/service/user.dart';
import 'package:vhome_repository/vhome_repository.dart';

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
  
  Future<bool> login(VhomeRepository repository, String username, String password) async {
    _authStateController.add(AuthState.pending);
    var user = await UserService().getAuthToken(username, password);
    if (user == null) {
      _authStateController.add(AuthState.unauthenticated);
      return false;
    }

    repository.setToken(user.token);

    _authStateController.add(AuthState.groupUnselected);
    return true;
  }

  Future<void> selectGroup(VhomeRepository repository, int groupId) async {
    _authStateController.add(AuthState.pending);
    var user = await UserService().selectGroup(repository, groupId);
    if (user == null) {
      _authStateController.add(AuthState.groupUnselected);
      return;
    }
    
    repository.setToken(user.token);

    _authStateController.add(AuthState.groupSelected);
  }

  Future<void> unselectGroup(VhomeRepository repository) async {
    _authStateController.add(AuthState.pending);
    var user = await UserService().unselectGroup(repository);
    if (user == null) {
      _authStateController.add(AuthState.unauthenticated);
      return;
    }
    
    repository.setToken(user.token);

    _authStateController.add(AuthState.groupUnselected);
  }


  Future<void> logout(VhomeRepository repository) async {
    _authStateController.add(AuthState.pending);
    await UserService().logout(repository);
    repository.unsetToken();
    _authStateController.add(AuthState.unauthenticated);
  }

  void dispose() {
    _authStateController.close();
  }
}
