import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vhome_repository/vhome_repository.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

part 'add_device_event.dart';
part 'add_device_state.dart';

class AddDeviceBloc extends Bloc<AddDeviceEvent, AddDeviceState> {
  AddDeviceBloc({
    required VhomeRepository repository,
  }) : _repository = repository, super(AddDeviceState()) {
    on<AddDeviceSubmitted>(_onSubmitted);
    on<AddDeviceNameChanged>(_onNameChanged);
    on<AddDeviceTypeSelected>(_onTypeSelected);
    on<AddDeviceReturnClicked>(_onReturnClicked);
  }

  final VhomeRepository _repository;

  void _onNameChanged(
    AddDeviceNameChanged event,
    Emitter<AddDeviceState> emit
  ) {
    emit(state.copyWith(name: event.name));
  }

  void _onTypeSelected(
    AddDeviceTypeSelected event,
    Emitter<AddDeviceState> emit
  ) {
    emit(state.copyWith(deviceType: event.type));
  }


  Future<void> _onSubmitted(
    AddDeviceSubmitted event,
    Emitter<AddDeviceState> emit,
  ) async {
    final name = state.name;
    final type = state.deviceType;

    if (type == null) {
      emit(state.copyWith(status: AddDeviceStatus.failure));
    } else {
      try {
        final returnedDevice = await _repository.addDevice(name, type);
        emit(state.copyWith(
          status: AddDeviceStatus.displayToken,
          token: returnedDevice.token)
        );
      } catch (_) {
        emit(state.copyWith(status: AddDeviceStatus.failure));
      }
    }
  }

  void _onReturnClicked(
    AddDeviceReturnClicked event,
    Emitter<AddDeviceState> emit
  ) {
    emit(state.copyWith(status: AddDeviceStatus.success));
  }
}
