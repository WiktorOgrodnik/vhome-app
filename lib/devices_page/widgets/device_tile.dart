import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vhome_frontend/devices_page/widgets/thermometer_content.dart';
import 'package:vhome_frontend/thermometer_details/view/view.dart';
import 'package:vhome_repository/vhome_repository.dart';

class DeviceTile extends StatelessWidget {
  const DeviceTile({required this.device, super.key});

  final Device device;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );

    final display = context.read<VhomeRepository>().display;

    final width = display ? 360.0 : 400.0;
    final height = display ? 360.0 : 400.0;
    
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
              width: width,
              height: height,
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
                        child: Center(child: Text("Last updated: ${DateFormat('yyyy-MM-dd – kk:mm').format(device.lastUpdated.toLocal()) }")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () =>
                            Navigator.of(context).push(
                              ThermometerDetailsPage.route(device as Thermometer) 
                            ),
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
          && DateTime.now().toLocal().difference(device.lastUpdated.toLocal()).inMinutes > 60)
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
