part of 'add_task_bloc.dart';

final class AddTaskState extends Equatable {
  const AddTaskState({
    required this.taskset,
    this.status = FormzSubmissionStatus.initial,
    this.title = const TaskTitle.pure(),
    this.content = const Content.pure(),
    this.isValid = false,
  });

  final FormzSubmissionStatus status;
  final Taskset taskset;
  final TaskTitle title;
  final Content content;
  final bool isValid;

  AddTaskState copyWith({
    FormzSubmissionStatus? status,
    Taskset? taskset,
    TaskTitle? title,
    Content? content,
    bool? isValid,
  }) {
    return AddTaskState(
      status: status ?? this.status,
      taskset: taskset ?? this.taskset,
      title: title ?? this.title,
      content: content ?? this.content,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [status, taskset, title, content, isValid];
}
