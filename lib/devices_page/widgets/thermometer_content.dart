import 'package:flutter/material.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

enum ThermometerDataType {
  temperature,
  humidity,
}

class ThermometerContent extends StatelessWidget {
  const ThermometerContent({super.key, required this.thermometer});

  final Thermometer thermometer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: Column(
        children: [
          Builder(
            builder: (context) {
              switch (thermometer.fields) {
                case ThermometerFields.onlyThermometer:
                  return FieldPanel(thermometer: thermometer, dataType: ThermometerDataType.temperature);
                case ThermometerFields.onlyHumidity:
                  return FieldPanel(thermometer: thermometer, dataType: ThermometerDataType.humidity);
                case ThermometerFields.thermometerHumidity:
                  return TemperatureHumidityPanel(thermometer: thermometer);
                default:
                  return const Placeholder();
              }
            }
          ),
        ],
      ),
    );
  }
}

class FieldPanel extends StatelessWidget {
  const FieldPanel({
    super.key,
    required this.thermometer,
    required this.dataType,
    this.micro = false,
  });
  final Thermometer thermometer;
  final ThermometerDataType dataType;
  final bool micro;

  @override
  Widget build(BuildContext context) {
    final icon = dataType == ThermometerDataType.temperature ?
                    Icons.thermostat : (dataType == ThermometerDataType.humidity ?
                                          Icons.water_drop : 
                                          null);
    final value = dataType == ThermometerDataType.temperature ?
                    thermometer.lastTemperature : (dataType == ThermometerDataType.humidity ?
                                          thermometer.lastHumidity : 
                                          null);

    final unit = dataType == ThermometerDataType.temperature ?
                    "°C" : (dataType == ThermometerDataType.humidity ?
                                          "%" : 
                                          null);
    final iconSize = micro ? 65.0 : 130.0;
    final textSize = micro ? 24.0 : 34.0;

    return Wrap(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
            ),
            Center(
              child: DefaultTextStyle(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                ),
                child: Text("$value $unit"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TemperatureHumidityPanel extends StatelessWidget {
  const TemperatureHumidityPanel({super.key, required this.thermometer});
  final Thermometer thermometer;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FieldPanel(thermometer: thermometer, dataType: ThermometerDataType.temperature, micro: true),
            SizedBox(width: 25),
            FieldPanel(thermometer: thermometer, dataType: ThermometerDataType.humidity, micro: true),
          ],
        ),
      ],
    );
  }
}
