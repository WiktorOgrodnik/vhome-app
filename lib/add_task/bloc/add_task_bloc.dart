import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vhome_repository/vhome_repository.dart';

part 'add_task_event.dart';
part 'add_task_state.dart';

class AddTaskBloc extends Bloc<AddTaskEvent, AddTaskState> {
  AddTaskBloc({
    required VhomeRepository repository,
    required Taskset taskset,
  }) : _repository = repository, super(AddTaskState(taskset: taskset)) {
    on<AddTaskSubmitted>(_onSubmitted);
    on<AddTaskTitleChanged>(_onTitleChanged);
    on<AddTaskContentChanged>(_onContentChanged);
  }

  final VhomeRepository _repository;

  void _onTitleChanged(
    AddTaskTitleChanged event,
    Emitter<AddTaskState> emit
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onContentChanged(
    AddTaskContentChanged event,
    Emitter<AddTaskState> emit
  ) {
    emit(state.copyWith(content: event.content));
  }


  Future<void> _onSubmitted(
    AddTaskSubmitted event,
    Emitter<AddTaskState> emit,
  ) async {
    final task = Task(
      title: state.title,
      content: state.content,
      tasksetId: state.taskset.id,
    );

    try {
      await _repository.addTask(task);
      emit(state.copyWith(status: AddTaskStatus.success));
    } catch (_) {
      emit(state.copyWith(status: AddTaskStatus.failure));
    }
  }

}
