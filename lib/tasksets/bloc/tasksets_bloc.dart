import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:vhome_repository/vhome_repository.dart';

part 'tasksets_event.dart';
part 'tasksets_state.dart';

class TasksetsBloc extends Bloc<TasksetsEvent, TasksetsState> {
  TasksetsBloc({
    required VhomeRepository repository
  }) : _repository = repository, super(const TasksetsState()) {
    on<TasksetsSubscriptionRequested>(_onTasksetsSubscriptionRequested);
  }
  
  final VhomeRepository _repository;

  Future<void> _onTasksetsSubscriptionRequested(
    TasksetsSubscriptionRequested event,
    Emitter<TasksetsState> emit,
  ) async {
    emit(state.copyWith(status: () => TasksetsStatus.loading));
    
    await emit.forEach<List<Taskset>>(
      _repository.getTasksets(),
      onData: (tasksets) => state.copyWith(
        status: () => TasksetsStatus.success,
        tasksets: () => tasksets,
      ),
      onError: (_, __) => state.copyWith(
        status: () => TasksetsStatus.failure,
      ),
    );
  }
}
