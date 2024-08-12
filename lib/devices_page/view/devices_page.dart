import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/add_device/view/add_device_page.dart';
import 'package:vhome_frontend/devices_page/bloc/devices_bloc.dart';
import 'package:vhome_frontend/devices_page/view/devices_list.dart';
import 'package:vhome_repository/vhome_repository.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DevicesBloc(repository: context.read<VhomeRepository>())
        ..add(DevicesSubscriptionRequested()),
      child: const TasksetsView(),   
    );
  }
}

class TasksetsView extends StatelessWidget {
  const TasksetsView({super.key});

  @override
  Widget build(BuildContext context) {
    final display = context.read<VhomeRepository>().display;

    final button = display
        ? FloatingActionButton(
            child: Icon(Icons.refresh),
            onPressed: () =>
              context
                .read<DevicesBloc>()
                .add(const DevicesRefresh()),
          )
        : FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              await Navigator.of(context).push(
                AddDevicePage.route(),
              );
            },
          );

    return Scaffold(
      body: DevicesList(),
      floatingActionButton: button, 
    );
  }
}
