part of 'taskset_details_bloc.dart';

sealed class TasksetDetailsEvent extends Equatable {
  const TasksetDetailsEvent();

  @override
  List<Object> get props => [];
}

final class TasksFetched extends TasksetDetailsEvent {
  const TasksFetched();
}

final class TaskAdded extends TasksetDetailsEvent {
  const TaskAdded();
}

final class TaskDeleted extends TasksetDetailsEvent {
  const TaskDeleted({required this.task});

  final Task task;

  @override
  List<Object> get props => [task];
}

final class TasksetDeleted extends TasksetDetailsEvent {
  const TasksetDeleted({required this.task});

  final Task task;

  @override
  List<Object> get props => [task];
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
