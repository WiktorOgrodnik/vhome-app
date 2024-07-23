part of 'devices_bloc.dart';

sealed class DevicesEvent extends Equatable {
  const DevicesEvent();

  @override
  List<Object> get props => [];
}

final class DevicesSubscriptionRequested extends DevicesEvent {
  const DevicesSubscriptionRequested();
}
