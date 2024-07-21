import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vhome_repository/vhome_repository.dart';

part 'add_taskset_event.dart';
part 'add_taskset_state.dart';

class AddTasksetBloc extends Bloc<AddTasksetEvent, AddTasksetState> {
  AddTasksetBloc({
    required VhomeRepository repository,
  }) : _repository = repository, super(AddTasksetState()) {
    on<AddTasksetSubmitted>(_onSubmitted);
    on<AddTasksetNameChanged>(_onNameChanged);
  }

  final VhomeRepository _repository;

  void _onNameChanged(
    AddTasksetNameChanged event,
    Emitter<AddTasksetState> emit
  ) {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _onSubmitted(
    AddTasksetSubmitted event,
    Emitter<AddTasksetState> emit,
  ) async {
    final name = state.name;

    try {
      await _repository.addTaskset(name);
      emit(state.copyWith(status: AddTasksetStatus.success));
    } catch (_) {
      emit(state.copyWith(status: AddTasksetStatus.failure));
    }
  }

}
