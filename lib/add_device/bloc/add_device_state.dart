part of 'add_device_bloc.dart';

enum AddDeviceStatus { form, displayToken, exit }

final class AddDeviceState extends Equatable {
  const AddDeviceState({
    this.status = AddDeviceStatus.form,
    this.formStatus = FormzSubmissionStatus.initial,
    this.name = const DeviceName.pure(),
    this.deviceType = const DeviceTypeModel.pure(),
    this.token = '',
    this.isValid = false,
  });

  final AddDeviceStatus status;
  final FormzSubmissionStatus formStatus;
  final DeviceName name;
  final DeviceTypeModel deviceType;
  final String token;
  final bool isValid;

  AddDeviceState copyWith({
    AddDeviceStatus? status,
    FormzSubmissionStatus? formStatus,
    DeviceName? name,
    DeviceTypeModel? deviceType,
    String? token,
    bool? isValid,
  }) {
    return AddDeviceState(
      status: status ?? this.status,
      formStatus: formStatus ?? this.formStatus,
      name: name ?? this.name,
      deviceType: deviceType ?? this.deviceType,
      token: token ?? this.token,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [status, formStatus, name, deviceType, token, isValid];
}
