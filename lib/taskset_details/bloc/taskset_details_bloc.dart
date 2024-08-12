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
    on<TasksSubscriptionRequested>(_onTasksSubscriptionRequested);
    on<TaskCompletionToggled>(_onTaskCompletionToggled);
    on<TasksetDeleted>(_onTasksetDeleted);
  }

  final VhomeRepository _repository;

  Future<void> _onTasksSubscriptionRequested(
    TasksSubscriptionRequested event,
    Emitter<TasksetDetailsState> emit,
  ) async {
    emit(state.copyWith(status: () => TasksetDetailsStatus.loading));

    await emit.forEach(
      _repository.getTasks(state.taskset.id),
      onData: (tasks) {
        return state.copyWith(
          status: () => TasksetDetailsStatus.success,
          tasks: () => tasks,
        );
      },
      onError: (_, __) => state.copyWith(
        status: () => TasksetDetailsStatus.failure,
      ),
    );
  }

  Future<void> _onTaskCompletionToggled(
    TaskCompletionToggled event,
    Emitter<TasksetDetailsState> emit,
  ) async {
    await _repository.toggleTaskCompletion(event.task, event.value); 
  }


  Future<void> _onTasksetDeleted(
    TasksetDeleted event,
    Emitter<TasksetDetailsState> emit,
  ) async {
    await _repository.deleteTaskset(event.taskset);
    emit(state.copyWith(status: () => TasksetDetailsStatus.deleted));
  }
}
