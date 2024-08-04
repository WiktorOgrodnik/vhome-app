part of 'users_bloc.dart';

enum UsersStatus {
  initial,
  loading,
  success,
  failure,
}

final class UsersState extends Equatable {
  const UsersState({
    this.status = UsersStatus.initial,
    this.users = const [],
  });

  final UsersStatus status;
  final List<User> users;

  UsersState copyWith({
    UsersStatus Function()? status,
    List<User> Function()? users,
  }) {
    return UsersState(
      status: status != null ? status() : this.status,
      users: users != null ? users() : this.users,
    );
  }

  @override
  List<Object?> get props => [status, users];
}
