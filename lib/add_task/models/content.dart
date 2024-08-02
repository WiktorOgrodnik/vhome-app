import 'package:formz/formz.dart';

enum ContentValidationError { none }

class Content extends FormzInput<String, ContentValidationError> {
  const Content.pure() : super.pure('');
  const Content.dirty([super.value = '']) : super.dirty();

  @override
  ContentValidationError? validator(String value) {
    return null;
  }
}
