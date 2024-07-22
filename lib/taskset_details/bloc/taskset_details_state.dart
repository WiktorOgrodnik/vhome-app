part of 'taskset_details_bloc.dart';

enum TasksetDetailsStatus {
  initial,
  loading,
  success,
  failure,
  deleted,
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
    TasksetDetailsStatus Function()? status,
    Taskset Function()? taskset,
    List<Task> Function()? tasks,
  }) {
    return TasksetDetailsState(
      status: status != null ? status() : this.status,
      taskset: taskset != null ? taskset() : this.taskset,
      tasks: tasks != null ? tasks() : this.tasks,
    );
  }

  @override
  List<Object?> get props => [status, taskset, tasks];
}
