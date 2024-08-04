import 'package:formz/formz.dart';

enum InvitationCodeValidationError { empty }

class InvitationCode extends FormzInput<String, InvitationCodeValidationError> {
  const InvitationCode.pure() : super.pure('');
  const InvitationCode.dirty([super.value = '']) : super.dirty();

  @override
  InvitationCodeValidationError? validator(String value) {
    if (value.isEmpty) return InvitationCodeValidationError.empty;
    return null;
  }
}
