part of 'add_device_bloc.dart';

sealed class AddDeviceEvent extends Equatable {
  const AddDeviceEvent();

  @override
  List<Object> get props => [];
}

final class AddDeviceNameChanged extends AddDeviceEvent {
  const AddDeviceNameChanged({required this.name});
  final String name;

  @override
  List<Object> get props => [name];
}

final class AddDeviceTypeSelected extends AddDeviceEvent {
  const AddDeviceTypeSelected({required this.type});
  final DeviceType type;

  @override
  List<Object> get props => [type];
}


final class AddDeviceSubmitted extends AddDeviceEvent {
  const AddDeviceSubmitted();
}

final class AddDeviceReturnClicked extends AddDeviceEvent {
  const AddDeviceReturnClicked();
}
