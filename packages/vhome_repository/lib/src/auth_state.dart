import 'package:equatable/equatable.dart';
import 'package:vhome_repository/vhome_repository.dart';

enum AuthStatus {
  pending,
  unauthenticated,
  groupUnselected,
  groupSelected;

  bool get hasToken =>
    this == AuthStatus.groupUnselected || this == AuthStatus.groupSelected;
}

class AuthState extends Equatable {
  const AuthState._({
    this.status = AuthStatus.pending,
    this.data,
  });

  const AuthState.pending() : this._();
  
  const AuthState.groupSelected(UserLogin data)
      : this._(status: AuthStatus.groupSelected, data: data);

  const AuthState.groupUnselected(UserLogin data)
      : this._(status: AuthStatus.groupUnselected, data: data);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);
 
  final AuthStatus status;
  final UserLogin? data;

  @override
  List<Object?> get props => [status, data];
}
