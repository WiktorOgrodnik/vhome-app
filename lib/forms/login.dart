import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/authenticate/authenticate.dart';
import 'package:vhome_frontend/components/buttons.dart';
import 'package:vhome_frontend/components/fields.dart';
import 'package:vhome_repository/vhome_repository.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();

  String? notEmpty (value) {
    if (value == null || value.isEmpty) {
      return 'This field can not be empty';
    }
    return null;
  }

  void scafforMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void onPressed(VhomeRepository repository) async {
    if (_formKey.currentState!.validate()) {
      var result = await Auth().login(repository, username.text, password.text);
        
      if (!result) {
        scafforMessage("User unauthorized!");
      }

    } else {
      scafforMessage("User unauthorized!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository = context.read<VhomeRepository>();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          StandardFormField(
            controller: username,
            validator: notEmpty, 
            hintText: "Login",
            obscureText: false,
          ),
          const SizedBox(height: 10),
          StandardFormField(
            controller: password,
            validator: notEmpty,
            hintText: "Password",
            obscureText: true,
          ),

          const SizedBox(height: 25),
          ConfirmButton(
            onPressed: () => onPressed(repository)
          )
        ],
      ),
    );
  }
}
