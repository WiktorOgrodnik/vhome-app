part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthState.pending,
    this.user,
  });

  const AuthenticationState.pending() : this._();
  
  const AuthenticationState.groupSelected(User user)
      : this._(status: AuthState.groupSelected, user: user);

  const AuthenticationState.groupUnselected(User user)
      : this._(status: AuthState.groupUnselected, user: user);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthState.unauthenticated);
  
  final AuthState status;
  final User? user;

  @override
  List<Object?> get props => [status, user];
}
