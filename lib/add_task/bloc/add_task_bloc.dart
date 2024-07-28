import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:vhome_frontend/add_task/add_task.dart';
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
    final title = TaskTitle.dirty(event.title); 
    emit(
      state.copyWith(
        title: title,
        isValid: Formz.validate([title, state.content])
      )
    );  
  }

  void _onContentChanged(
    AddTaskContentChanged event,
    Emitter<AddTaskState> emit
  ) {
    final content = Content.dirty(event.content); 
    emit(
      state.copyWith(
        content: content,
        isValid: Formz.validate([state.title, content])
      )
    );
  }


  Future<void> _onSubmitted(
    AddTaskSubmitted event,
    Emitter<AddTaskState> emit,
  ) async {

    final task = Task(
      title: state.title.value,
      content: state.content.value,
      tasksetId: state.taskset.id,
    );

    try {
      await _repository.addTask(task);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

}
