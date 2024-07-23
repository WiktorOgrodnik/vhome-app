import 'package:flutter/material.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

class DeviceTile extends StatelessWidget {
  const DeviceTile({required this.device, super.key});

  final Device device;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );

    var styleSubText = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );

    return Material(
      elevation: 4,
      color: Colors.transparent,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          width: 400,
          height: 600,
          child: AnimatedSize(
            duration: Duration(milliseconds: 200),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    device.name,
                    style: style,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "Recent changes:",
                      style: styleSubText,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Builder(
                      builder: (context) {
                        switch (device.deviceType) {
                          case DeviceType.thermometer:
                            return Builder(
                              builder: (context) {
                                final thermometer = device as Thermometer;
                                return Column(
                                  children: [
                                    Text("Current Temperature: ${thermometer.lastTemperature}"),
                                    Text("Last updated: ${thermometer.lastUpdated}"),
                                  ], 
                                );
                              }
                            );
                          default:
                            return const Placeholder();
                        }
                      }
                    ),
                  ),
                  const Spacer(flex: 2),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Center(
                        child: Text("More..."),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
