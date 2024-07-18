import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart';
import 'package:vhome_frontend/auth.dart';
import 'package:vhome_frontend/components/buttons.dart';
import 'package:vhome_frontend/components/fields.dart';

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

  void onPressed() async {
    if (_formKey.currentState!.validate()) {
      var result = await Auth().login(username.text, password.text);
        
      if (!result) {
        scafforMessage("User unauthorized!");
      }

    } else {
      scafforMessage("User unauthorized!");
    }
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}
