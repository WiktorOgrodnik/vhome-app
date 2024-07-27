part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

final class _AuthenticationStatusChanged extends AuthenticationEvent {
  const _AuthenticationStatusChanged({
    required this.status,
  });

  final AuthState status;
}

final class AuthenticationLogoutRequested extends AuthenticationEvent {}

final class AuthenticationGroupUnselectionRequested extends AuthenticationEvent {}
