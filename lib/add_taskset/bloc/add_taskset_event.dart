part of 'add_taskset_bloc.dart';

sealed class AddTasksetEvent extends Equatable {
  const AddTasksetEvent();

  @override
  List<Object> get props => [];
}


final class AddTasksetNameChanged extends AddTasksetEvent {
  const AddTasksetNameChanged({required this.name});
  final String name;

  @override
  List<Object> get props => [name];
}

final class AddTasksetSubmitted extends AddTasksetEvent {
  const AddTasksetSubmitted();
}
