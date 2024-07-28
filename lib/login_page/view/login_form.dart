import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:vhome_frontend/login_page/bloc/login_bloc.dart';
import 'package:vhome_frontend/widgets/confirm_button.dart';
import 'package:vhome_frontend/widgets/standard_field.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text("Authentication Failure."))
            );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 25),
            _UsernameInput(),
            const SizedBox(height: 25),
            _PasswordInput(),
            const SizedBox(height: 25),
            _LoginButton(),
          ],
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return StandardFormField(
          hintText: 'username', 
          onChanged: (username) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(username)),
          errorText: state.username.displayError != null ? 'username can not be empty' : null,
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return StandardFormField(
          obscureText: true,
          hintText: 'password',
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          errorText: state.password.displayError != null ? 'password can not be empty' : null,
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ConfirmButton(
                onPressed: state.isValid
                    ? () {
                        context.read<LoginBloc>().add(const LoginSubmitted());
                      }
                    : null,
                child: Text("Sign in"),
              );
      },
    );
  }
}
