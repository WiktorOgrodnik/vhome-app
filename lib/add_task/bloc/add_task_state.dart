part of 'add_task_bloc.dart';

enum AddTaskStatus { initial, success, failure }

final class AddTaskState extends Equatable {
  const AddTaskState({
    required this.taskset,
    this.status = AddTaskStatus.initial,
    this.title = '',
    this.content = '',
  });

  final AddTaskStatus status;
  final Taskset taskset;
  final String title;
  final String content;

  AddTaskState copyWith({
    AddTaskStatus? status,
    Taskset? taskset,
    String? title,
    String? content,
  }) {
    return AddTaskState(
      status: status ?? this.status,
      taskset: taskset ?? this.taskset,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  @override
  List<Object?> get props => [status, taskset, title, content];
}
