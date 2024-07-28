import 'package:formz/formz.dart';

enum TitleValidationError { empty }

class TaskTitle extends FormzInput<String, TitleValidationError> {
  const TaskTitle.pure() : super.pure('');
  const TaskTitle.dirty([super.value = '']) : super.dirty();

  @override
  TitleValidationError? validator(String value) {
    if (value.isEmpty) return TitleValidationError.empty;
    return null;
  }
}
