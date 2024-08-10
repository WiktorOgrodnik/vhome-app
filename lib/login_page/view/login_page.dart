import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/login_page/bloc/login_bloc.dart';
import 'package:vhome_frontend/login_page/view/view.dart';
import 'package:vhome_frontend/register/view/view.dart';
import 'package:vhome_repository/vhome_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login to Vhome account"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 1000,
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
                    BlocProvider(
                      create: (context) => 
                        LoginBloc(repository: context.read<VhomeRepository>()),
                      child: const LoginForm(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: ElevatedButton(
                        onPressed: () =>
                          Navigator.of(context).push(
                            RegisterPage.route(),
                          ),
                        child: Text("Create new account"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
