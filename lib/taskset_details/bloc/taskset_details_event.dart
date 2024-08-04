part of 'taskset_details_bloc.dart';

sealed class TasksetDetailsEvent extends Equatable {
  const TasksetDetailsEvent();

  @override
  List<Object> get props => [];
}

final class TasksSubscriptionRequested extends TasksetDetailsEvent {
  const TasksSubscriptionRequested();
}

final class TasksetDeleted extends TasksetDetailsEvent {
  const TasksetDeleted({required this.taskset});

  final Taskset taskset;

  @override
  List<Object> get props => [taskset];
}

final class TaskCompletionToggled extends TasksetDetailsEvent {
  const TaskCompletionToggled({
    required this.task,
    required this.value,
  });

  final Task task;
  final bool value;

  @override
  List<Object> get props => [task, value];
}
