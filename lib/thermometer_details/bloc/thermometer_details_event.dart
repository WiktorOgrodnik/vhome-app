part of 'thermometer_details_bloc.dart';

sealed class ThermometerDetailsEvent extends Equatable {
  const ThermometerDetailsEvent();

  @override
  List<Object> get props => [];
}

final class ThermometerSubscriptionRequested extends ThermometerDetailsEvent {
  const ThermometerSubscriptionRequested();
}

final class MeasurementsRequested extends ThermometerDetailsEvent {
  const MeasurementsRequested();
}

final class ThermometerRefreshed extends ThermometerDetailsEvent {
  const ThermometerRefreshed();
}

final class ThermometerDeleted extends ThermometerDetailsEvent {
  const ThermometerDeleted();
}
