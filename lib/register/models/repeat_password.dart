import 'package:formz/formz.dart';

enum RepeatPasswordValidationError { empty, mismatch }

class RepeatPassword extends FormzInput<String, RepeatPasswordValidationError> {
  final String password;
  
  const RepeatPassword.pure({
    this.password = ''
  }) : super.pure('');

  const RepeatPassword.dirty({
    required this.password,
    String value = ''
  }) : super.dirty(value);

  @override
  RepeatPasswordValidationError? validator(String value) {
    if (value.isEmpty) return RepeatPasswordValidationError.empty;
    if (password != value) return RepeatPasswordValidationError.mismatch;

    return null;
  }
}

extension Explanation on RepeatPasswordValidationError {
  String? get name {
    switch(this) {
      case RepeatPasswordValidationError.empty:
        return 'repeat password can not be empty';
      case RepeatPasswordValidationError.mismatch:
        return 'passwords not match';
      default:
        return null;
    }
  }
}
