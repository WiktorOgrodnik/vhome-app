part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

final class _AuthenticationStatusChanged extends AuthenticationEvent {
  const _AuthenticationStatusChanged({
    required this.status,
  });

  final AuthState status;

  @override
  List<Object> get props => [status];
}

final class AuthenticationLogoutRequested extends AuthenticationEvent {
  
}

final class AuthenticationGroupSelected extends AuthenticationEvent {
  const AuthenticationGroupSelected({required this.group});

  final Group group;

  @override
  List<Object> get props => [group];
}

final class AuthenticationGroupUnselectionRequested extends AuthenticationEvent {}
