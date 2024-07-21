import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:vhome_repository/vhome_repository.dart';


part 'taskset_details_event.dart';
part 'taskset_details_state.dart';

class TasksetDetailsBloc extends Bloc<TasksetDetailsEvent, TasksetDetailsState> {
  TasksetDetailsBloc({
      required VhomeRepository repository,
      required Taskset taskset,
    }) : _repository = repository, super(TasksetDetailsState(taskset: taskset)) {
    on<TasksFetched>(_onTasksFetched);
    on<TaskCompletionToggled>(_onTaskCompletionToggled);
  }

  final VhomeRepository _repository;

  Future<void> _onTasksFetched(
    TasksFetched event,
    Emitter<TasksetDetailsState> emit,
  ) async {
    try {
      final tasks = await _repository.getTasks(state.taskset.id);
      print(tasks.length);
      emit(
        state.copyWith(
          status: TasksetDetailsStatus.success,
          tasks: tasks,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: TasksetDetailsStatus.failure));
    }
  }

  Future<void> _onTaskCompletionToggled(
    TaskCompletionToggled event,
    Emitter<TasksetDetailsState> emit,
  ) async {
    try {
      await _repository.toggleTaskCompletion(event.task, event.value); 
    } catch (error) {
      print(error);
    }
  }
}
