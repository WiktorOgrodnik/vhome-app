part of 'task_details_bloc.dart';

sealed class TaskDetailsEvent extends Equatable {
  const TaskDetailsEvent();

  @override
  List<Object> get props => [];
}

final class TaskSubscriptionRequested extends TaskDetailsEvent {
  const TaskSubscriptionRequested();
}

final class TaskDeleted extends TaskDetailsEvent {
  const TaskDeleted();
}

final class TaskAssignUser extends TaskDetailsEvent {
  const TaskAssignUser({required this.user, required this.add});

  final int user;
  final bool add;

  @override
  List<Object> get props => [user, add];
}

final class TaskCompletionToggled extends TaskDetailsEvent {
  const TaskCompletionToggled({
    required this.value,
  });

  final bool value;

  @override
  List<Object> get props => [value];
}
