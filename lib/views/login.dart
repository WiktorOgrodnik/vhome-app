import 'package:flutter/material.dart';
import 'package:vhome_frontend/forms/login.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() {
    print("Sign in clicked ${userNameController.text} ${passwordController.text}");
     
  }

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
