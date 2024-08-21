part of 'thermometer_details_bloc.dart';

enum ThermometerDetailsStatus {
  initial,
  loading,
  success,
  failure,
  deleted,
}

enum MeasurementsStatus {
  initial,
  loading,
  success,
  failure,
}

final class ThermometerDetailsState extends Equatable {
  const ThermometerDetailsState({
    this.status = ThermometerDetailsStatus.initial,
    this.measurementsStatus = MeasurementsStatus.initial,
    required this.thermometer,
    this.measurements = const [],
    this.timeRange = MeasurementTimeRange.week,
  });

  final ThermometerDetailsStatus status;
  final MeasurementsStatus measurementsStatus;
  final Thermometer thermometer;
  final List<Measurement> measurements;
  final MeasurementTimeRange timeRange;

  ThermometerDetailsState copyWith({
    ThermometerDetailsStatus Function()? status,
    MeasurementsStatus Function()? measurementsStatus,
    Thermometer Function()? thermometer,
    List<Measurement> Function()? measurements,
    MeasurementTimeRange Function()? timeRange,
  }) {
    return ThermometerDetailsState(
      status: (status != null && this.status != ThermometerDetailsStatus.deleted) ? status() : this.status,
      measurementsStatus: measurementsStatus != null ? measurementsStatus() : this.measurementsStatus,
      thermometer: thermometer != null ? thermometer() : this.thermometer,
      measurements: measurements != null ? measurements() : this.measurements,
      timeRange: timeRange != null ? timeRange() : this.timeRange,
    );
  }

  @override
  List<Object> get props => [status, measurementsStatus, thermometer, measurements, timeRange];
}
