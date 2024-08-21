import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:vhome_frontend/add_device/models/models.dart';
import 'package:vhome_repository/vhome_repository.dart';

part 'add_device_event.dart';
part 'add_device_state.dart';

class AddDeviceBloc extends Bloc<AddDeviceEvent, AddDeviceState> {
  AddDeviceBloc({
    required VhomeRepository repository,
    Device? device
  }) : _repository = repository, super(AddDeviceState(
    id: device?.id ?? 0,
    name: device != null ? DeviceName.dirty(device.name) : DeviceName.pure(),
    edit: device != null,
  )) {
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
    final name = DeviceName.dirty(event.name);
    emit(
      state.copyWith(
        name: name,
        isValid: Formz.validate([name, state.deviceType]),
      )
    );
  }

  void _onTypeSelected(
    AddDeviceTypeSelected event,
    Emitter<AddDeviceState> emit
  ) {
    final deviceType = DeviceTypeModel.dirty(event.type);
    emit(
      state.copyWith(
        deviceType: deviceType,
        isValid: Formz.validate([state.name, deviceType]),
      )
    );
  }

  Future<void> _onSubmitted(
    AddDeviceSubmitted event,
    Emitter<AddDeviceState> emit,
  ) async {
    emit(state.copyWith(formStatus: FormzSubmissionStatus.inProgress));
    final name = state.name.value;
    final type = state.deviceType.value;

    print(name);

    try {
      if (!state.edit) {
        final returnedDevice = await _repository.addDevice(name, type);
        emit(state.copyWith(
          status: AddDeviceStatus.displayToken,
          formStatus: FormzSubmissionStatus.success,
          token: returnedDevice.token
        ));
      } else {
        await _repository.editDevice(state.id, name);
        emit(state.copyWith(
          status: AddDeviceStatus.exit,
          formStatus: FormzSubmissionStatus.success,
        ));
      }
    } catch (_) {
      emit(state.copyWith(formStatus: FormzSubmissionStatus.failure));
    }
  }

  void _onReturnClicked(
    AddDeviceReturnClicked event,
    Emitter<AddDeviceState> emit
  ) {
    emit(state.copyWith(status: AddDeviceStatus.exit));
  }
}
