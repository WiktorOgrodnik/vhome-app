import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vhome_frontend/devices_page/widgets/thermometer_content.dart';
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
    
    return Stack(
      children: [
        Material(
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
              height: 400,
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
                        padding: const EdgeInsets.all(12.0),
                        child: ThermometerContent(thermometer: device as Thermometer),
                      ),
                      const Spacer(flex: 2),
                      if (device.deviceType == DeviceType.thermometer)
                        DefaultTextStyle(
                          style: DefaultTextStyle.of(context).style.copyWith(fontStyle: FontStyle.italic),
                          child: Center(child: Text("Last updated: ${DateFormat('yyyy-MM-dd – kk:mm').format((device as Thermometer).lastUpdated.toLocal()) }")),
                        ),
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
        ),
        if (device.deviceType == DeviceType.thermometer 
          && DateTime.now().toLocal().difference((device as Thermometer).lastUpdated.toLocal()).inMinutes > 60)
          Positioned(
            top: 5,
            right: 10,
            child: Tooltip(
              message: "This device has not been updated for a long time.",
              child: Icon(
                Icons.warning_rounded,
                color: Colors.yellow,
                size: 30,
              ),
            ),
          ),
      ],
    );
  }
}
