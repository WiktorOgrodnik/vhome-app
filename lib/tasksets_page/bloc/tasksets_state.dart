part of 'tasksets_bloc.dart';

enum TasksetsStatus {
  initial,
  loading,
  success,
  failure,
}

final class TasksetsState extends Equatable {
  const TasksetsState({
    this.status = TasksetsStatus.initial,
    this.tasksets = const [],
  });

  final TasksetsStatus status;
  final List<Taskset> tasksets;

  TasksetsState copyWith({
    TasksetsStatus Function()? status,
    List<Taskset> Function()? tasksets,
  }) {
    return TasksetsState(
      status: status != null ? status() : this.status,
      tasksets: tasksets != null ? tasksets() : this.tasksets,
    );
  }

  @override
  List<Object?> get props => [
    status,
    tasksets,
  ];
}
