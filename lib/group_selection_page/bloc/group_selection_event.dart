part of 'group_selection_bloc.dart';

sealed class GroupSelectionEvent extends Equatable {
  const GroupSelectionEvent();

  @override
  List<Object> get props => [];
}

final class GroupSubscriptionRequested extends GroupSelectionEvent {}
