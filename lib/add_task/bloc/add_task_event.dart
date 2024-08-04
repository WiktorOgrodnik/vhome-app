part of 'add_task_bloc.dart';

sealed class AddTaskEvent extends Equatable {
  const AddTaskEvent();

  @override
  List<Object> get props => [];
}


final class AddTaskTitleChanged extends AddTaskEvent {
  const AddTaskTitleChanged({required this.title});
  final String title;

  @override
  List<Object> get props => [title];
}

final class AddTaskContentChanged extends AddTaskEvent {
  const AddTaskContentChanged({required this.content});
  final String content;

  @override
  List<Object> get props => [content];
}

final class TaskDeleted extends AddTaskEvent {
  const TaskDeleted({required this.task});

  final Task task;

  @override
  List<Object> get props => [task];
}


final class AddTaskSubmitted extends AddTaskEvent {
  const AddTaskSubmitted();
}
