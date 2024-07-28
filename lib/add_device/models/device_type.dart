import 'package:formz/formz.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

enum DeviceTypeValidationError { empty }

class DeviceTypeModel extends FormzInput<DeviceType, DeviceTypeValidationError> {
  const DeviceTypeModel.pure() : super.pure(DeviceType.other);
  const DeviceTypeModel.dirty([super.value = DeviceType.other]) : super.dirty();

  @override
  DeviceTypeValidationError? validator(DeviceType value) {
    if (value == DeviceType.other) return DeviceTypeValidationError.empty;
    return null;
  }
}
