import 'package:formz/formz.dart';

enum ContentValidationError { empty }

class Content extends FormzInput<String, ContentValidationError> {
  const Content.pure() : super.pure('');
  const Content.dirty([super.value = '']) : super.dirty();

  @override
  ContentValidationError? validator(String value) {
    if (value.isEmpty) return ContentValidationError.empty;
    return null;
  }
}
