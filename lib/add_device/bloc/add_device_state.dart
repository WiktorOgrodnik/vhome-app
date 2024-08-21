part of 'add_device_bloc.dart';

enum AddDeviceStatus { form, displayToken, exit }

final class AddDeviceState extends Equatable {
  const AddDeviceState({
    this.status = AddDeviceStatus.form,
    this.formStatus = FormzSubmissionStatus.initial,
    this.id = 0,
    this.name = const DeviceName.pure(),
    this.deviceType = const DeviceTypeModel.pure(),
    this.token = '',
    this.isValid = false,
    this.edit = true,
  });

  final AddDeviceStatus status;
  final int id;
  final FormzSubmissionStatus formStatus;
  final DeviceName name;
  final DeviceTypeModel deviceType;
  final String token;
  final bool isValid;
  final bool edit;

  AddDeviceState copyWith({
    AddDeviceStatus? status,
    FormzSubmissionStatus? formStatus,
    int? id,
    DeviceName? name,
    DeviceTypeModel? deviceType,
    String? token,
    bool? isValid,
    bool? edit,
  }) {
    return AddDeviceState(
      status: status ?? this.status,
      formStatus: formStatus ?? this.formStatus,
      id: id ?? this.id,
      name: name ?? this.name,
      deviceType: deviceType ?? this.deviceType,
      token: token ?? this.token,
      isValid: isValid ?? this.isValid,
      edit: edit ?? this.edit,
    );
  }

  @override
  List<Object> get props => [
    status,
    formStatus,
    id,
    name,
    deviceType,
    token,
    isValid,
    edit
  ];
}
