part of 'add_group_bloc.dart';

sealed class AddGroupEvent extends Equatable {
  const AddGroupEvent();

  @override
  List<Object> get props => [];
}


final class AddGroupNameChanged extends AddGroupEvent {
  const AddGroupNameChanged({required this.name});
  final String name;

  @override
  List<Object> get props => [name];
}

final class AddGroupSubmitted extends AddGroupEvent {
  const AddGroupSubmitted();
}
