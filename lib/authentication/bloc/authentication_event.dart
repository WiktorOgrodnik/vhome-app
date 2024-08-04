part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

final class _AuthenticationStateChanged extends AuthenticationEvent {
  const _AuthenticationStateChanged({
    required this.state,
  });

  final AuthState state;

  @override
  List<Object> get props => [state];
}

final class AuthenticationLogoutRequested extends AuthenticationEvent {}

final class AuthenticationGroupSelected extends AuthenticationEvent {
  const AuthenticationGroupSelected({required this.group});

  final Group group;

  @override
  List<Object> get props => [group];
}

final class AuthenticationGroupUnselectionRequested extends AuthenticationEvent {}

final class AuthenticationGroupLeaveRequested extends AuthenticationEvent {}
