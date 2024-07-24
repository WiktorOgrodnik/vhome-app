import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/add_device/add_device.dart';
import 'package:vhome_repository/vhome_repository.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

enum AddDeviceTypeLabel {
  other('---', DeviceType.other),
  thermometer('Thermometer', DeviceType.thermometer);

  const AddDeviceTypeLabel(this.label, this.type);
  final String label;
  final DeviceType type;
}

class AddDevicePage extends StatelessWidget {
  const AddDevicePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => AddDeviceBloc(
          repository: context.read<VhomeRepository>()
        ),
        child: const AddDevicePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddDeviceBloc, AddDeviceState>(
          listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == AddDeviceStatus.success,
          listener: (context, state) => Navigator.of(context).pop(),
          child: const AddDeviceView(),
        ),
        BlocListener<AddDeviceBloc, AddDeviceState>(
          listenWhen: (previous, current) =>
            previous.status != current.status,
          listener: (context, state) {
            if (state.status == AddDeviceStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text("Failed to add device."),
                    ),
                  );
              }
          },
          child: const AddDeviceView(),
        )
      ],
      child: BlocBuilder<AddDeviceBloc, AddDeviceState>(
        builder: (context, state) {
          switch (state.status) {
            case AddDeviceStatus.displayToken:
              return const AddDeviceTokenPage();
            default:
              return const AddDeviceView();
          }
        },
      ),
    );

  }
}

class AddDeviceView extends StatelessWidget {
  const AddDeviceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add device"),
      ),
      body: const Row(
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
          SizedBox(
            width: 1000,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _NameField(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: _DeviceTypeSelector(),
                      ),
                      SizedBox(height: 25),
                      _AcceptButton(),
                    ]
                  ),
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        context
          .read<AddDeviceBloc>()
          .add(AddDeviceNameChanged(name: value));
      },
    );
  }
}

class _DeviceTypeSelector extends StatelessWidget {
  const _DeviceTypeSelector();

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<AddDeviceTypeLabel>(
      requestFocusOnTap: true,
      initialSelection: AddDeviceTypeLabel.other,
      label: const Text('Type'),
      onSelected: (AddDeviceTypeLabel? type) {
        context
          .read<AddDeviceBloc>()
          .add(AddDeviceTypeSelected(type: type!.type));
      },
      dropdownMenuEntries: AddDeviceTypeLabel.values
        .map<DropdownMenuEntry<AddDeviceTypeLabel>>(
          (AddDeviceTypeLabel type) {
            return DropdownMenuEntry<AddDeviceTypeLabel>(
              value: type,
              label: type.label,
            );
          }
        ).toList()
    );
  }
}

class _AcceptButton extends StatelessWidget {
  const _AcceptButton();

  @override
  Widget build(BuildContext context) {
    final status = context.select((AddDeviceBloc bloc) => bloc.state.status);

    return ElevatedButton(
      onPressed: status == AddDeviceStatus.initial ?
        () => context.read<AddDeviceBloc>().add(const AddDeviceSubmitted())
        : null,
      child: Text("Add"),
    );
  }
}
