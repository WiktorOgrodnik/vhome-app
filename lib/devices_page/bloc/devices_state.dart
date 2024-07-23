part of 'devices_bloc.dart';

enum DevicesStatus {
  initial,
  loading,
  success,
  failure,
}

final class DevicesState extends Equatable {
  const DevicesState({
    this.status = DevicesStatus.initial,
    this.devices = const [],
  });

  final DevicesStatus status;
  final List<Device> devices;

  DevicesState copyWith({
    DevicesStatus Function()? status,
    List<Device> Function()? devices,
  }) {
    return DevicesState(
      status: status != null ? status() : this.status,
      devices: devices != null ? devices() : this.devices,
    );
  }

  @override
  List<Object?> get props => [
    status, devices,
  ];
}
