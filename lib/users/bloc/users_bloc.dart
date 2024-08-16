import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_selector/file_selector.dart';
import 'package:vhome_repository/vhome_repository.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc({
      required VhomeRepository repository,
    }) : _repository = repository, super(UsersState()) {
    on<UsersSubscriptionRequested>(_onUsersSubscriptionRequested);
    on<UsersUploadProfilePictureRequested>(_onUsersUploadProfilePictureRequested);
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

  Future<void> _onUsersUploadProfilePictureRequested( 
    UsersUploadProfilePictureRequested event,
    Emitter<UsersState> emit,
  ) async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'images',
      extensions: <String>['png'],
    );
    final XFile? file =
      await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

    emit(state.copyWith(status: () => UsersStatus.loading));

    if (file != null) {
      _repository.uploadProfilePicture(await file.readAsBytes());
      emit(state.copyWith(status: () => UsersStatus.success));
    } else {
      emit(state.copyWith(status: () => UsersStatus.failure));
    }
  }
}
