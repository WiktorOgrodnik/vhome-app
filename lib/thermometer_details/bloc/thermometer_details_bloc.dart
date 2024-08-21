import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:vhome_repository/vhome_repository.dart';

part 'thermometer_details_event.dart';
part 'thermometer_details_state.dart';

class ThermometerDetailsBloc extends Bloc<ThermometerDetailsEvent, ThermometerDetailsState> {
  ThermometerDetailsBloc({
      required VhomeRepository repository,
      required Thermometer thermometer,
    }) : _repository = repository, super(ThermometerDetailsState(thermometer: thermometer)) {
    on<ThermometerSubscriptionRequested>(_onThermometerSubscriptionRequested);
    on<MeasurementsRequested>(_onMeasurementsRequested);
    on<ThermometerRefreshed>(_onThermometerRefreshed);
    on<ThermometerDeleted>(_onThermometerDeleted);
  }

  final VhomeRepository _repository;

  Future<void> _onThermometerSubscriptionRequested(
    ThermometerSubscriptionRequested event,
    Emitter<ThermometerDetailsState> emit,
  ) async {
    emit(state.copyWith(status: () => ThermometerDetailsStatus.loading));

    await emit.forEach(
      _repository.getDevice(state.thermometer.id),
      onData: (thermometer) {
        return state.copyWith(
          status: () => ThermometerDetailsStatus.success,
          thermometer: () => (thermometer as Thermometer),
        );
      },
      onError: (_, __) => state.copyWith(
        status: () => ThermometerDetailsStatus.failure,
      ),
    );
  }

  Future<void> _onMeasurementsRequested(
    MeasurementsRequested event,
    Emitter<ThermometerDetailsState> emit
  ) async {
    emit(state.copyWith(measurementsStatus: () => MeasurementsStatus.loading));
    
    try {
      final measurements = await _repository.getMeasurements(state.thermometer.id, event.timeRange);
      emit(
        state.copyWith(
          measurementsStatus: () => MeasurementsStatus.success,
          measurements: () => measurements,
        )
      );
    } catch (_) {
      emit(state.copyWith(measurementsStatus: () => MeasurementsStatus.failure));
    }
  }

  void _onThermometerRefreshed(
    ThermometerRefreshed event,
    Emitter<ThermometerDetailsState> emit,
  ) {
    _repository.refreshDevices();
  }

  Future<void> _onThermometerDeleted(
    ThermometerDeleted event,
    Emitter<ThermometerDetailsState> emit,
  ) async {
    await _repository.deleteDevice(state.thermometer.id);
    emit(state.copyWith(status: () => ThermometerDetailsStatus.deleted));
  }
}
