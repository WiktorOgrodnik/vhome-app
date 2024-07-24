part of 'add_device_bloc.dart';

enum AddDeviceStatus { initial, displayToken, success, failure }

final class AddDeviceState extends Equatable {
  const AddDeviceState({
    this.status = AddDeviceStatus.initial,
    this.name = '',
    this.deviceType,
    this.token = '',
  });

  final AddDeviceStatus status;
  final String name;
  final DeviceType? deviceType;
  final String token;

  AddDeviceState copyWith({
    AddDeviceStatus? status,
    String? name,
    DeviceType? deviceType,
    String? token,
  }) {
    return AddDeviceState(
      status: status ?? this.status,
      name: name ?? this.name,
      deviceType: deviceType ?? this.deviceType,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [status, name, deviceType, token];
}
