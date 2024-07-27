part of 'groups_selection_bloc.dart';

sealed class GroupsSelectionEvent extends Equatable {
  const GroupsSelectionEvent();

  @override
  List<Object> get props => [];
}

final class GroupSelectd extends GroupsSelectionEvent {}
