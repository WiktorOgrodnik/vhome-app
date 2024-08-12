import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/settings/bloc/settings_bloc.dart';
import 'package:vhome_frontend/widgets/widgets.dart';

class SettingsPairDisplayCodePage extends StatelessWidget {
  SettingsPairDisplayCodePage({super.key});
 
  static Route<void> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => SettingsPairDisplayCodePage(),
    );
  }

  final controller = TextEditingController();
 
  @override    
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 1000,
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SectionTitle(
                    child: Text("Paste pairing code here."),
                  ),
                  SizedBox(height: 25),
                  _PairingCodeField(controller),
                  SizedBox(height: 25),
                  _Button(
                    text: "Pair",
                    onPressed: () =>
                      context
                        .read<SettingsBloc>()
                        .add(SettingsPairDisplayCodeSubmitted(controller.text)),
                  ),
                  SizedBox(height: 25),
                  _Button(
                    text: "Return",
                    onPressed: () =>
                      context
                        .read<SettingsBloc>()
                        .add(SettingsOverviewReturned()),
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

class _PairingCodeField extends StatelessWidget {
  const _PairingCodeField(this.controller);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: controller,
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({required this.text, this.onPressed});

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {

    return ConfirmButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
