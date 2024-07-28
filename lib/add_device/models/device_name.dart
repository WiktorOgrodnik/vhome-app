import 'package:formz/formz.dart';

enum DeviceNameValidationError { empty }

class DeviceName extends FormzInput<String, DeviceNameValidationError> {
  const DeviceName.pure() : super.pure('');
  const DeviceName.dirty([super.value = '']) : super.dirty();

  @override
  DeviceNameValidationError? validator(String value) {
    if (value.isEmpty) return DeviceNameValidationError.empty;
    return null;
  }
}
