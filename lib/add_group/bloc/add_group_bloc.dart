import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:vhome_frontend/add_group/models/name.dart';
import 'package:vhome_repository/vhome_repository.dart';

part 'add_group_event.dart';
part 'add_group_state.dart';

class AddGroupBloc extends Bloc<AddGroupEvent, AddGroupState> {
  AddGroupBloc({
    required VhomeRepository repository,
  }) : _repository = repository, super(AddGroupState()) {
    on<AddGroupSubmitted>(_onSubmitted);
    on<AddGroupNameChanged>(_onNameChanged);
  }

  final VhomeRepository _repository;

  void _onNameChanged(
    AddGroupNameChanged event,
    Emitter<AddGroupState> emit
  ) {
    final name = Name.dirty(event.name);
    emit(
      state.copyWith(
        name: name,
        isValid: Formz.validate([name]),
      )
    );
  }

  Future<void> _onSubmitted(
    AddGroupSubmitted event,
    Emitter<AddGroupState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _repository.addGroup(state.name.value);
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
