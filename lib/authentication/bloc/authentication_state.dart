part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthState.pending,
    this.user,
  });

  const AuthenticationState.pending() : this._();
  
  const AuthenticationState.groupSelected(AuthModel user)
      : this._(status: AuthState.groupSelected, user: user);

  const AuthenticationState.groupUnselected(AuthModel user)
      : this._(status: AuthState.groupUnselected, user: user);

  const AuthenticationState.unauthenticated(AuthModel? user)
      : this._(status: AuthState.unauthenticated, user: user);
 
  final AuthState status;
  final AuthModel? user;

  @override
  List<Object?> get props => [status, user];
}
