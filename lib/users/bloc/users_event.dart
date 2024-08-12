part of 'users_bloc.dart';

sealed class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

final class UsersSubscriptionRequested extends UsersEvent {
  const UsersSubscriptionRequested();
}

final class UserTaskAssigned extends UsersEvent {
  const UserTaskAssigned({
    required this.task,
    required this.user,
    required this.value
  });

  final int task;
  final User user;
  final bool value;

  @override
  List<Object> get props => [task, user, value];
}

final class UsersUploadProfilePictureRequested extends UsersEvent {}
