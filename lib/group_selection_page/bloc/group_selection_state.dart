part of 'group_selection_bloc.dart';

enum GroupSelectionStatus {
  initial,
  loading,
  success,
  failure,
}

final class GroupSelectionState extends Equatable {
  const GroupSelectionState({
    this.status = GroupSelectionStatus.initial,
    this.groups = const [],
  });

  final GroupSelectionStatus status;
  final List<Group> groups;
  
  GroupSelectionState copyWith({
    GroupSelectionStatus Function()? status,
    List<Group> Function()? groups,
  }) {
    return GroupSelectionState(
      status: status != null ? status() : this.status,
      groups: groups != null ? groups() : this.groups,
    );
  }

  @override
  List<Object> get props => [status, groups];
}
