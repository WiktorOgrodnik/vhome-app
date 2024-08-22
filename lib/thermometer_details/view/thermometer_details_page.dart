import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vhome_frontend/add_device/view/add_device_page.dart';
import 'package:vhome_frontend/devices_page/widgets/thermometer_content.dart';
import 'package:vhome_frontend/thermometer_details/bloc/thermometer_details_bloc.dart';
import 'package:vhome_frontend/widgets/widgets.dart';
import 'package:vhome_repository/vhome_repository.dart';

enum MeasurementTimeRangeLabel {
  hour('an hour', MeasurementTimeRange.hour),
  day('a day', MeasurementTimeRange.day),
  week('a week', MeasurementTimeRange.week),
  month('a month', MeasurementTimeRange.month);

  const MeasurementTimeRangeLabel(this.label, this.type);
  final String label;
  final MeasurementTimeRange type;
}

class ThermometerDetailsPage extends StatelessWidget {
  const ThermometerDetailsPage({super.key, required this.thermometer});

  final Thermometer thermometer;

  static Route<void> route(Thermometer thermometer) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => ThermometerDetailsPage(thermometer: thermometer),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThermometerDetailsBloc(
        repository: context.read<VhomeRepository>(),
        thermometer: thermometer,
      )
        ..add(const MeasurementsRequested(MeasurementTimeRange.week))
        ..add(const ThermometerSubscriptionRequested()),
      child: const ThermometerDetailsListener(),
    );
  }
}

class ThermometerDetailsListener extends StatelessWidget {
  const ThermometerDetailsListener();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ThermometerDetailsBloc, ThermometerDetailsState>(
      listenWhen: (previous, current) =>
        previous.status != current.status &&
        current.status == ThermometerDetailsStatus.deleted,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const ThermometerDetailsView(),
    );
  }
}

class ThermometerDetailsView extends StatelessWidget {
  const ThermometerDetailsView();

  @override
  Widget build(BuildContext context) {
    final display = context.read<VhomeRepository>().display;

    return BlocBuilder<ThermometerDetailsBloc, ThermometerDetailsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("${state.thermometer.name} details"),
            actions: [
              if (!display)
              IconButton(
                onPressed: () =>
                  Navigator.of(context).push(
                    AddDevicePage.route(device: state.thermometer),
                  ),
                tooltip: "Edit device",
                icon: const Icon(Icons.edit),
              ),
              if (!display)
              IconButton(
                onPressed: () =>
                  context
                    .read<ThermometerDetailsBloc>()
                    .add(ThermometerDeleted()),
                tooltip: "Delete device",
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
          body: Container(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 1200,
              child: Column(
                children: [
                  ThermometerContent(thermometer: state.thermometer),
                  const SizedBox(height: 25),
                  const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: SectionTitle(child: Text("History")),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: _MeasurementTimeRangeDropdownMenu(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: const MeasurementChart(),
                    ),
                  ), 
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}

class MeasurementsList extends StatelessWidget {
  const MeasurementsList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThermometerDetailsBloc, ThermometerDetailsState>(
      builder: (context, state) {
        switch (state.measurementsStatus) {
          case MeasurementsStatus.failure:
            return const Center(child: Text("Failed"));
          case MeasurementsStatus.success:
            if (state.measurements.isEmpty) {
              return const Center(child: Text("No measurements yet."));
            }

            return ListView.builder(
              itemCount: state.measurements.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("${state.measurements[index].label}: ${state.measurements[index].value}"),
                  subtitle: Text(state.measurements[index].time.toLocal().toString()),
                );
              }
            );

          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class MeasurementChart extends StatelessWidget {
  const MeasurementChart();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThermometerDetailsBloc, ThermometerDetailsState>(
      builder: (context, state) {
        switch (state.measurementsStatus) {
          case MeasurementsStatus.failure:
            return const Center(child: Text("Failed"));
          case MeasurementsStatus.success:
            if (state.measurements.isEmpty) {
              return const Center(child: Text("No measurements yet."));
            }

            List<Measurement> measurements = state.measurements;
            measurements.sort((a, b) => a.time.compareTo(b.time));

            return SfCartesianChart(
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
              ),
              primaryXAxis: DateTimeAxis(
                dateFormat: DateFormat("yyyy-MM-dd hh:mm:ss"),
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: "Temperature"),
                labelFormat: '{value}°C',
                minimum: measurements.where((measurement) 
                  => measurement.label == "last_temp").map((measurement) => measurement.value).reduce(min) - 1,
                maximum: measurements.where((measurement)
                  => measurement.label == "last_temp").map((measurement) => measurement.value).reduce(max) + 1,
              ),
              axes: [
                NumericAxis(
                  name: "yAxis",
                  labelFormat: '{value}%',
                  title: AxisTitle(text: 'Humidity'),
                  opposedPosition: true,
                )
              ],
              series: [
                LineSeries<Measurement, DateTime>(
                  name: "Temperature",
                  dataSource: measurements.where((measurement) => measurement.label == "last_temp").toList(),
                  xValueMapper: (Measurement m, _) => m.time.toLocal(),
                  yValueMapper: (Measurement m, _) => m.value,
                ),
                LineSeries<Measurement, DateTime>(
                  name: "Humidity",
                  dataSource: measurements.where((measurement) => measurement.label == "last_humidity").toList(),
                  xValueMapper: (Measurement m, _) => m.time.toLocal(),
                  yValueMapper: (Measurement m, _) => m.value,
                  yAxisName: "yAxis",
                ),
              ],
            );

          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class _MeasurementTimeRangeDropdownMenu extends StatelessWidget {
  const _MeasurementTimeRangeDropdownMenu();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThermometerDetailsBloc, ThermometerDetailsState>(
      builder: (context, state) {
        return DropdownMenu<MeasurementTimeRangeLabel>(
          requestFocusOnTap: true,
          initialSelection: MeasurementTimeRangeLabel.week,
          label: const Text('Type'),
          onSelected: (MeasurementTimeRangeLabel? type) =>
            context
              .read<ThermometerDetailsBloc>()
              .add(MeasurementsRequested(type!.type)),
          dropdownMenuEntries: MeasurementTimeRangeLabel.values
            .map<DropdownMenuEntry<MeasurementTimeRangeLabel>>(
              (MeasurementTimeRangeLabel type) {
                return DropdownMenuEntry<MeasurementTimeRangeLabel>(
                  value: type,
                  label: type.label,
                );
              }
            ).toList(),
        );
      }
    );
  }    
}        
