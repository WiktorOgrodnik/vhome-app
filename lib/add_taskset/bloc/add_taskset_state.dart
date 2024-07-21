part of 'add_taskset_bloc.dart';

enum AddTasksetStatus { initial, success, failure }

final class AddTasksetState extends Equatable {
  const AddTasksetState({
    this.status = AddTasksetStatus.initial,
    this.name = '',
  });

  final AddTasksetStatus status;
  final String name;

  AddTasksetState copyWith({
    AddTasksetStatus? status,
    String? name,
  }) {
    return AddTasksetState(
      status: status ?? this.status,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [status, name];
}
