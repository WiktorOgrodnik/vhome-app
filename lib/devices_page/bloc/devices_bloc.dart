import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:vhome_repository/vhome_repository.dart';

part 'devices_event.dart';
part 'devices_state.dart';

class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  DevicesBloc({
    required VhomeRepository repository
  }) : _repository = repository, super(const DevicesState()) {
    on<DevicesSubscriptionRequested>(_onDevicesSubscriptionRequested);
    on<DevicesRefresh>(_onDevicesRefresh);
  }
  
  final VhomeRepository _repository;

  Future<void> _onDevicesSubscriptionRequested(
    DevicesSubscriptionRequested event,
    Emitter<DevicesState> emit,
  ) async {
    emit(state.copyWith(status: () => DevicesStatus.loading));
    
    await emit.forEach<List<Device>>(
      _repository.getDevices(),
      onData: (devices) => state.copyWith(
        status: () => DevicesStatus.success,
        devices: () => devices, 
      ),
      onError: (_, __) => state.copyWith(
        status: () => DevicesStatus.failure,
      ),
    );
  }

  void _onDevicesRefresh(
    DevicesRefresh event,
    Emitter<DevicesState> emit,
  ) {
    _repository.refreshDevices();
  }
}
