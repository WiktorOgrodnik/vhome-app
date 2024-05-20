import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart';
import 'package:vhome_frontend/auth.dart';
import 'package:vhome_frontend/components/buttons.dart';
import 'package:vhome_frontend/components/fields.dart';
import 'package:vhome_frontend/consts/api_url.dart';

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
      var response = await post(
        Uri.parse("$apiUrl/authenticate"),
        body: jsonEncode({
          'login': username.text,
          'passwd': password.text}),
      );

      if (response.statusCode == 200 && response.headers.containsKey('set-cookie') && response.body.startsWith("Logged user:")) {
        var cookie = response.headers['set-cookie']!;
        
        if (cookie.contains("tide.sid")) {
          await SessionManager()
            .set("session.sid", cookie);

          scafforMessage("User logged in! Msg: ${response.body}");

          var response2 = await post(
            Uri.parse("$apiUrl/setgroup/1"),
            headers: {
              "cookie": cookie, 
            },
          );

          if (response2.statusCode != 200) {
            print(response2.statusCode);
            scafforMessage("Set group failed!");
          }

          await Auth().login(username.text, password.text);
        } else {
          scafforMessage("Session error!");
        }
      } else {
        scafforMessage("User unauthorized!");
      }
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
