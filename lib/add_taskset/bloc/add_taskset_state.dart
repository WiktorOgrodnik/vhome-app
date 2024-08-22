part of 'add_taskset_bloc.dart';

final class AddTasksetState extends Equatable {
  const AddTasksetState({
    this.status = FormzSubmissionStatus.initial,
    this.id = 0,
    this.name = const Name.pure(),
    this.isValid = false,
    this.edit = false,
  });

  final FormzSubmissionStatus status;
  final int id;
  final Name name;
  final bool isValid;
  final bool edit;

  AddTasksetState copyWith({
    FormzSubmissionStatus? status,
    int? id,
    Name? name,
    bool? isValid,
    bool? edit
  }) {
    return AddTasksetState(
      status: status ?? this.status,
      id: id ?? this.id,
      name: name ?? this.name,
      isValid: isValid ?? this.isValid,
      edit: edit ?? this.edit,
    );
  }

  @override
  List<Object?> get props => [status, id, name, isValid, edit];
}
