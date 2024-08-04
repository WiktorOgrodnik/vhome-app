import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/settings/bloc/settings_bloc.dart';
import 'package:vhome_frontend/widgets/widgets.dart';

class SettingsGroupInivitationPage extends StatelessWidget {
  const SettingsGroupInivitationPage({super.key});
 
  static Route<void> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => SettingsGroupInivitationPage(),
    );
  }
 
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
                    child: Text("Send this inivitation code to a friend."),
                  ),
                  SizedBox(height: 25),
                  _TokenField(),
                  SizedBox(height: 25),
                  _ReturnButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    ); 
  }
}

class _TokenField extends StatelessWidget {
  const _TokenField();

  @override
  Widget build(BuildContext context) {
    final state = context.select((SettingsBloc bloc) => bloc.state);
    final controller = TextEditingController(text: state.invitation);

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        suffixIcon: IconButton(
          onPressed: () {
              Clipboard.setData(ClipboardData(text: state.invitation));
          },
          icon: Icon(Icons.copy_all)
        ),
      ),
      readOnly: true,
    );
  }
}

class _ReturnButton extends StatelessWidget {
  const _ReturnButton();

  @override
  Widget build(BuildContext context) {

    return ConfirmButton(
      onPressed: () =>
        context
          .read<SettingsBloc>()
          .add(SettingsOverviewReturned()),
      child: Text("Return"),
    );
  }
}
