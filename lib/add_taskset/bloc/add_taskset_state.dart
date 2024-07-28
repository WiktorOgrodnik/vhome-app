part of 'add_taskset_bloc.dart';

final class AddTasksetState extends Equatable {
  const AddTasksetState({
    this.status = FormzSubmissionStatus.initial,
    this.name = const Name.pure(),
    this.isValid = false,
  });

  final FormzSubmissionStatus status;
  final Name name;
  final bool isValid;

  AddTasksetState copyWith({
    FormzSubmissionStatus? status,
    Name? name,
    bool? isValid,
  }) {
    return AddTasksetState(
      status: status ?? this.status,
      name: name ?? this.name,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [status, name, isValid];
}
