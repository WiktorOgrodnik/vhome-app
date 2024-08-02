import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vhome_repository/vhome_repository.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc({
      required VhomeRepository repository,
    }) : _repository = repository, super(UsersState()) {
    on<UsersSubscriptionRequested>(_onUsersSubscriptionRequested);
    on<UserTaskAssigned>(_onUserTaskAssigned);
  }

  final VhomeRepository _repository;

  Future<void> _onUsersSubscriptionRequested(
    UsersSubscriptionRequested event,
    Emitter<UsersState> emit,
  ) async {
    emit(state.copyWith(status: () => UsersStatus.loading));

    await emit.forEach(
      _repository.getUsers(),
      onData: (users) => state.copyWith(
        status: () => UsersStatus.success,
        users: () => users,
      ),
      onError: (_, __) => state.copyWith(
        status: () => UsersStatus.failure,
      ),
    );
  }

  Future<void> _onUserTaskAssigned(
    UserTaskAssigned event,
    Emitter<UsersState> emit,
  ) async {
    try {
      await _repository.changeAssign(event.task, event.user, event.value);
    } catch (error) {
      print(error);
    }

    _repository.refreshUsers();
  }
}
