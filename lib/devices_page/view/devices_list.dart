import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/devices_page/devices_page.dart';

class DevicesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevicesBloc, DevicesState> (
      builder: (context, state) {
        switch (state.status) {
          case DevicesStatus.failure:
            return const Center(child: Text("failed to fetch devices."));
          case DevicesStatus.success:
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                children: [
                  for (var device in state.devices)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: DeviceTile(device: device),
                    ),
                ],
              ),
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
