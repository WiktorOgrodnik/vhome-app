part of 'groups_selection_bloc.dart';

enum GroupsSelectionStatus {
  initial,
  loading,
  success,
  failure,
}

final class GroupsSelectionState extends Equatable {
  const GroupsSelectionState({
    this.status = GroupsSelectionStatus.initial,
    this.groups = const [],
  });

  final GroupsSelectionStatus status;
  final List<Group> groups;
  
  GroupsSelectionState copyWith({
    GroupsSelectionStatus Function()? status,
    List<Group> Function()? groups,
  }) {
    return GroupsSelectionState(
      status: status != null ? status() : this.status,
      groups: groups != null ? groups() : this.groups,
    );
  }

  @override
  List<Object> get props => [status, groups];
}
