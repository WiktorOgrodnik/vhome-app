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
    Taskset? taskset,
    Task? task,
  }) : _repository = repository,
      super(AddTaskState(
              id: task != null ? task.id : taskset!.id,
              title: task != null ? TaskTitle.dirty(task.title) : TaskTitle.pure(),
              content: task != null ? Content.dirty(task.content) : Content.pure(),
              edit: task != null,
            )
      ) {
    on<AddTaskSubmitted>(_onSubmitted);
    on<AddTaskTitleChanged>(_onTitleChanged);
    on<AddTaskContentChanged>(_onContentChanged);
    on<TaskDeleted>(_onTaskDeleted);
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

  Future<void> _onTaskDeleted(
    TaskDeleted event,
    Emitter<AddTaskState> emit,
  ) async {
    await _repository.deleteTask(event.task);
    emit(state.copyWith(status: AddDeviceStatus.deleted));
  }


  Future<void> _onSubmitted(
    AddTaskSubmitted event,
    Emitter<AddTaskState> emit,
  ) async {
    final task = state.edit
      ? Task(
          id: state.id,
          title: state.title.value,
          content: state.content.value,
          taskAssigned: const [],
        )
      : Task(
          title: state.title.value,
          content: state.content.value,
          tasksetId: state.id,
          taskAssigned: [],
        );

    try {
      
      if (state.edit) {
        await _repository.editTask(task);
      } else {
        await _repository.addTask(task);
      }

      emit(state.copyWith(formStatus: FormzSubmissionStatus.success));
    } catch (_) {
      emit(state.copyWith(formStatus: FormzSubmissionStatus.failure));
    }
  }

}
