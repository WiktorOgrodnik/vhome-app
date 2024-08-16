part of 'add_task_bloc.dart';

final class AddTaskState extends Equatable {
  const AddTaskState({
    this.formStatus = FormzSubmissionStatus.initial,
    this.id = 0,
    this.title = const TaskTitle.pure(),
    this.content = const Content.pure(),
    this.isValid = false,
    this.edit = false,
  });

  final FormzSubmissionStatus formStatus;
  final int id;
  final TaskTitle title;
  final Content content;
  final bool isValid;
  final bool edit;

  AddTaskState copyWith({
    FormzSubmissionStatus? formStatus,
    int? id,
    TaskTitle? title,
    Content? content,
    List<int>? taskAssigned,
    bool? isValid,
    bool? edit,
  }) {
    return AddTaskState(
      formStatus: formStatus ?? this.formStatus,
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isValid: isValid ?? this.isValid,
      edit: edit ?? this.edit,
    );
  }

  @override
  List<Object> get props => [formStatus, id, title, content, isValid, edit];
}
