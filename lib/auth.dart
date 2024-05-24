import 'dart:async';

enum AuthState {
  pending,
  unauthenticated,
  authenticated,
}

class Auth {
  static final Auth _instance = Auth._internal();
  factory Auth() => _instance;
  Auth._internal() {
    _authStateController.add(AuthState.unauthenticated); // Initial state
    // Simulate an authentication check
    _checkAuthStatus();
  }

  final _authStateController = StreamController<AuthState>.broadcast();

  // Expose the stream
  Stream<AuthState> get authState$ => _authStateController.stream;

  void _checkAuthStatus() async {
    // Simulate a delay for checking auth status
    await Future.delayed(Duration(milliseconds: 50));
    // This is where you would check if the user is authenticated
    // For demonstration, let's assume the user is unauthenticated
    _authStateController.add(AuthState.unauthenticated);
  }

  Future<void> login(String username, String password) async {
    _authStateController.add(AuthState.pending);
    // Simulate a login delay
    // Here, you would verify the username and password
    // For demonstration, let's assume login is successful
    _authStateController.add(AuthState.authenticated);
  }

  Future<void> logout() async {
    // Simulate a logout delay
    // After logging out, update the state
    _authStateController.add(AuthState.unauthenticated);
  }

  void dispose() {
    _authStateController.close();
  }
}
