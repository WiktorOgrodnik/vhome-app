import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:vhome_frontend/add_taskset/models/name.dart';
import 'package:vhome_repository/vhome_repository.dart';

part 'add_taskset_event.dart';
part 'add_taskset_state.dart';

class AddTasksetBloc extends Bloc<AddTasksetEvent, AddTasksetState> {
  AddTasksetBloc({
    required VhomeRepository repository,
    Taskset? taskset,
  }) : _repository = repository, super(AddTasksetState(
    id: taskset?.id ?? 0,
    name: taskset != null ? Name.dirty(taskset.title) : const Name.pure(),
    edit: taskset != null,
  )) {
    on<AddTasksetSubmitted>(_onSubmitted);
    on<AddTasksetNameChanged>(_onNameChanged);
  }

  final VhomeRepository _repository;

  void _onNameChanged(
    AddTasksetNameChanged event,
    Emitter<AddTasksetState> emit
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
    AddTasksetSubmitted event,
    Emitter<AddTasksetState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {

        if (state.edit) {
          final taskset = Taskset(id: state.id, title: state.name.value);
          await _repository.editTaskset(taskset);
        } else {
          await _repository.addTaskset(state.name.value);
        }

        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
