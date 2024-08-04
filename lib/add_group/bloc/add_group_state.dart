part of 'add_group_bloc.dart';

final class AddGroupState extends Equatable {
  const AddGroupState({
    this.status = FormzSubmissionStatus.initial,
    this.name = const Name.pure(),
    this.isValid = false,
  });

  final FormzSubmissionStatus status;
  final Name name;
  final bool isValid;

  AddGroupState copyWith({
    FormzSubmissionStatus? status,
    Name? name,
    bool? isValid,
  }) {
    return AddGroupState(
      status: status ?? this.status,
      name: name ?? this.name,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [status, name, isValid];
}
