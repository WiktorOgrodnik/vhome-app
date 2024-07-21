part of 'tasksets_bloc.dart';

sealed class TasksetsEvent extends Equatable {
  const TasksetsEvent();

  @override
  List<Object> get props => [];
}

final class TasksetsSubscriptionRequested extends TasksetsEvent {
  const TasksetsSubscriptionRequested();
}
