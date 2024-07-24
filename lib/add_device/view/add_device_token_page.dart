
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/add_device/bloc/add_device_bloc.dart';

class AddDeviceTokenPage extends StatelessWidget {
  const AddDeviceTokenPage({super.key});

  @override    
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Save token"),
      ),
      body: Row(
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
                      _Title(),
                      SizedBox(height: 25),
                      _TokenField(),
                      SizedBox(height: 25),
                      _Info(),
                      SizedBox(height: 25),
                      _ReturnButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();
  
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        color: Colors.black,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
      child: Text("Your new device token"),
    );
  }
}

class _TokenField extends StatelessWidget {
  const _TokenField();

  @override
  Widget build(BuildContext context) {
    final state = context.select((AddDeviceBloc bloc) => bloc.state);
    final controller = TextEditingController(text: state.token);

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        suffixIcon: IconButton(
          onPressed: () {
              Clipboard.setData(ClipboardData(text: state.token));
          },
          icon: Icon(Icons.copy_all)
        ),
      ),
      readOnly: true,
    );
  }
}

class _Info extends StatelessWidget {
  const _Info();
  
  @override
  Widget build(BuildContext context) {
    return Text("Save this token. There is no return to this site.");
  }
}

class _ReturnButton extends StatelessWidget {
  const _ReturnButton();

  @override
  Widget build(BuildContext context) {
    final status = context.select((AddDeviceBloc bloc) => bloc.state.status);

    return ElevatedButton(
      onPressed: status == AddDeviceStatus.displayToken ?
        () => context.read<AddDeviceBloc>().add(const AddDeviceReturnClicked())
        : null,
      child: Text("Return"),
    );
  }
}
