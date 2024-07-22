import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/authenticate/authenticate.dart';
import 'package:vhome_frontend/widgets/confirm_button.dart';
import 'package:vhome_frontend/widgets/standard_field.dart';
import 'package:vhome_repository/vhome_repository.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final _formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();

  String? notEmpty (value) {
    if (value == null || value.isEmpty) {
      return 'This field can not be empty';
    }
    return null;
  }

  void onPressed(VhomeRepository repository) async {
    if (_formKey.currentState!.validate()) {
      await Auth().login(repository, username.text, password.text);
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

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Icon(
              Icons.lock,
              size: 100,
            ),
            const SizedBox(height: 50),
            Text(
              "Welcome back!",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}
