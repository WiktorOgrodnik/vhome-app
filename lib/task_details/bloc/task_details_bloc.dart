import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vhome_repository/vhome_repository.dart';

part 'task_details_event.dart';
part 'task_details_state.dart';

class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  TaskDetailsBloc({
      required VhomeRepository repository,
      required Task task,
    }) : _repository = repository, super(TaskDetailsState(task: task)) {
    on<TaskSubscriptionRequested>(_onTaskSubscriptionRequested);
    on<TaskDeleted>(_onTasksetDeleted);
    on<TaskAssignUser>(_onTaskAssignUser);
    on<TaskCompletionToggled>(_onTaskCompletionToggled);
  }

  final VhomeRepository _repository;

  Future<void> _onTaskSubscriptionRequested(
    TaskSubscriptionRequested event,
    Emitter<TaskDetailsState> emit,
  ) async {
    emit(state.copyWith(status: () => TaskDetailsStatus.loading));

    await emit.forEach(
      _repository.getTask(state.task.id),
      onData: (task) {
        return state.copyWith(
          status: () => TaskDetailsStatus.success,
          task: () => task,
        );
      },
      onError: (_, __) => state.copyWith(
        status: () => TaskDetailsStatus.failure,
      ),
    );
  }

  Future<void> _onTasksetDeleted(
    TaskDeleted event,
    Emitter<TaskDetailsState> emit,
  ) async {
    await _repository.deleteTask(state.task);
    emit(state.copyWith(status: () => TaskDetailsStatus.deleted));
  }

  Future<void> _onTaskAssignUser(
    TaskAssignUser event,
    Emitter<TaskDetailsState> emit
  ) async {
    await _repository.changeAssign(state.task.id, event.user, event.add);
  }

  Future<void> _onTaskCompletionToggled(
    TaskCompletionToggled event,
    Emitter<TaskDetailsState> emit,
  ) async {
    await _repository.toggleTaskCompletion(state.task, event.value);
  }
}
