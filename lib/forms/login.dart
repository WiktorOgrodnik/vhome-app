import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart';
import 'package:vhome_frontend/auth.dart';
import 'package:vhome_frontend/components/buttons.dart';
import 'package:vhome_frontend/components/fields.dart';
import 'package:vhome_frontend/consts/api_url.dart';
import 'package:vhome_frontend/models/user.dart';

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
        Uri.parse("$apiUrl/login"),
        body: jsonEncode({
          'username': username.text,
          'password': password.text,
        }),
        headers: {
          "Accept": "application/json",
          "content-type":"application/json"
        },
      );

      if (response.statusCode == 200) {
        var user = User.fromJson(jsonDecode(response.body));
        var token = user.token;

        await SessionManager().set("user.token", token);

        scafforMessage("User logged in! Msg: ${response.body}");

        var response2 = await get(
          Uri.parse("$apiUrl/group/select/1"),
          headers: {
            "Authorization": token, 
          },
        );

        if (response2.statusCode != 200) {
          scafforMessage("Set group failed!");
        } else {
          var user = User.fromJson(jsonDecode(response2.body));
          var token = user.token;
          await SessionManager().set("user.token", token);
          await Auth().login(username.text, password.text);
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
