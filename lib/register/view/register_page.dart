import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:vhome_frontend/register/register.dart';
import 'package:vhome_frontend/widgets/widgets.dart';
import 'package:vhome_repository/vhome_repository.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key}); 

  static Route<void> route({Taskset? taskset, Task? task}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => RegisterBloc(
          repository: context.read<VhomeRepository>(),
        ),
        child: RegisterPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RegisterBloc, RegisterState>(
          listenWhen: (previous, current) =>
            previous.formStatus != current.formStatus &&
            current.formStatus.isSuccess,
          listener: (context, state) => Navigator.of(context).pop(),
        ),
        BlocListener<RegisterBloc, RegisterState>(
          listenWhen: (previous, current) =>
            previous.formStatus != current.formStatus &&
            current.formStatus.isFailure,
          listener: (context, state) => 
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text("Failed to register user!")
                )
              )
        ),
      ],
      child: RegisterView(),
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register")
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 1000,
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _UserProfilePicture(),
                    SizedBox(height: 25),
                    _UsernameField(),
                    SizedBox(height: 25),
                    _PasswordField(),
                    SizedBox(height: 25),
                    _RepeatPasswordField(),
                    SizedBox(height: 25),
                    _AcceptButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}

class _UserProfilePicture extends StatelessWidget {
  const _UserProfilePicture();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<RegisterBloc, RegisterState>(
          buildWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == RegisterStatus.ready,
          builder: (context, state) {
            if (state.picture == null) {
              return UserIcon(AssetImage("assets/profile_picture.png"), size: 150.0);
            } else {
              return UserIcon(MemoryImage(state.picture!), size: 150.0);
            }
          }
        ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.grey,
              shape: CircleBorder(),
            ),
            child: IconButton(
              onPressed: () =>
                context
                  .read<RegisterBloc>()
                  .add(RegisterUserPictureChangeRequested()),
              icon: Icon(Icons.edit_rounded),
            ),
          ),
        )
      ]
    );
  }
}

class _UsernameField extends StatelessWidget {
  const _UsernameField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return StandardFormField(
          hintText: "Username",
          onChanged: (value) => context.read<RegisterBloc>().add(RegisterUsernameChanged(username: value)),
          errorText: state.username.displayError != null ? 'username can not be null' : null,
        );
      }
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return StandardFormField(
          hintText: "Password",
          obscureText: true,
          onChanged: (value) => context.read<RegisterBloc>().add(RegisterPasswordChanged(password: value)),
          errorText: state.password.displayError != null ? 'password can not be null' : null,
        );
      }
    );
  }
}

class _RepeatPasswordField extends StatelessWidget {
  const _RepeatPasswordField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.repeatPassword != current.repeatPassword,
      builder: (context, state) {
        return StandardFormField(
          hintText: "Repeat Password",
          obscureText: true,
          onChanged: (value) => context.read<RegisterBloc>().add(RegisterRepeatPasswordChanged(repeatPassword: value)),
          errorText: state.repeatPassword.displayError?.name,
        );
      }
    );
  }
}

class _AcceptButton extends StatelessWidget {
  const _AcceptButton();

  @override
  Widget build(BuildContext context) {
    final state = context.select((RegisterBloc bloc) => bloc.state);

    return state.formStatus.isInProgress
        ? const CircularProgressIndicator()
        : ConfirmButton(
            onPressed: state.isValid 
              ? () => context.read<RegisterBloc>().add(const RegisterSubmitted())
              : null,
            child: Text("Register"), 
          );
  }
}
