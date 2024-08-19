import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vhome_frontend/devices_page/widgets/thermometer_content.dart';
import 'package:vhome_frontend/thermometer_details/bloc/thermometer_details_bloc.dart';
import 'package:vhome_frontend/widgets/widgets.dart';
import 'package:vhome_repository/vhome_repository.dart';

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
        ..add(const ThermometerSubscriptionRequested())
        ..add(const MeasurementsRequested()),
      child: const ThermometerDetailsListener(),
    );
  }
}

class ThermometerDetailsListener extends StatelessWidget {
  const ThermometerDetailsListener();

  @override
  Widget build(BuildContext context) {
    return const ThermometerDetailsView();
  }
}

class ThermometerDetailsView extends StatelessWidget {
  const ThermometerDetailsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThermometerDetailsBloc, ThermometerDetailsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("${state.thermometer.name} details"),
          ),
          body: Container(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 1200,
              child: Column(
                children: [
                  ThermometerContent(thermometer: state.thermometer),
                  const SizedBox(height: 25),
                  const SectionTitle(child: Text("History")),
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

            return SfCartesianChart(
              primaryXAxis: DateTimeAxis(
                dateFormat: DateFormat("yyyy-MM-dd hh:mm:ss"),
              ),
              primaryYAxis: NumericAxis(
                minimum: state.measurements.where((measurement) => measurement.label == "last_temp").map((measurement) => measurement.value).reduce(min) - 1,
                maximum: state.measurements.where((measurement) => measurement.label == "last_temp").map((measurement) => measurement.value).reduce(max) + 1,
              ),
              axes: [
                NumericAxis(
                  name: "yAxis",
                  title: AxisTitle(text: 'Secondary y-axis'),
                  opposedPosition: true,
                )
              ],
              series: [
                LineSeries<Measurement, DateTime>(
                  dataSource: state.measurements.where((measurement) => measurement.label == "last_temp").toList(),
                  xValueMapper: (Measurement m, _) => m.time.toLocal(),
                  yValueMapper: (Measurement m, _) => m.value,
                ),
                LineSeries<Measurement, DateTime>(
                  dataSource: state.measurements.where((measurement) => measurement.label == "last_humidity").toList(),
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
