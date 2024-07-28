import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vhome_repository/vhome_repository.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

part 'group_selection_event.dart';
part 'group_selection_state.dart';

class GroupSelectionBloc extends Bloc<GroupSelectionEvent, GroupSelectionState> {
  GroupSelectionBloc({
    required VhomeRepository repository,
  }) : _repository = repository, super(const GroupSelectionState()) {
    on<GroupSubscriptionRequested>(_onGroupSubscriptionRequested);
  }

  final VhomeRepository _repository;

  Future<void> _onGroupSubscriptionRequested(
    GroupSubscriptionRequested event,
    Emitter<GroupSelectionState> emit,
  ) async {
    emit(state.copyWith(status: () => GroupSelectionStatus.loading));

    await emit.forEach(
      _repository.getGroups(),
      onData: (groups) => state.copyWith(
        status: () => GroupSelectionStatus.success,
        groups: () => groups,
      ),
      onError: (_, __) => state.copyWith(
        status: () => GroupSelectionStatus.failure,
      ),
    );
  }
}
