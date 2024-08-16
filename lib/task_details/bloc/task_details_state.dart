part of 'task_details_bloc.dart';

enum TaskDetailsStatus {
  initial,
  loading,
  success,
  failure,
  deleted,
}

final class TaskDetailsState extends Equatable {
  const TaskDetailsState({
    this.status = TaskDetailsStatus.initial,
    required this.task,
  });

  final TaskDetailsStatus status;
  final Task task;

  TaskDetailsState copyWith({
    TaskDetailsStatus Function()? status,
    Task Function()? task,
  }) {
    return TaskDetailsState(
      status: (status != null && this.status != TaskDetailsStatus.deleted) ? status() : this.status,
      task: task != null ? task() : this.task,
    );
  }

  @override
  List<Object?> get props => [status, task];
}
