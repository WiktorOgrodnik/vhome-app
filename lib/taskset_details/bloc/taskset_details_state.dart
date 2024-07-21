part of 'taskset_details_bloc.dart';

enum TasksetDetailsStatus {
  initial,
  loading,
  success,
  failure,
}

final class TasksetDetailsState extends Equatable {
  const TasksetDetailsState({
    this.status = TasksetDetailsStatus.initial,
    this.tasks = const [],
    required this.taskset,
  });

  final TasksetDetailsStatus status;
  final Taskset taskset;
  final List<Task> tasks;

  TasksetDetailsState copyWith({
    TasksetDetailsStatus? status,
    Taskset? taskset,
    List<Task>? tasks,
  }) {
    return TasksetDetailsState(
      status: status ?? this.status,
      taskset: taskset ?? this.taskset,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  List<Object?> get props => [status, taskset, tasks];
}
