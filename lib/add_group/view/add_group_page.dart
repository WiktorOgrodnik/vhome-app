import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:vhome_frontend/add_group/bloc/add_group_bloc.dart';
import 'package:vhome_frontend/widgets/confirm_button.dart';
import 'package:vhome_frontend/widgets/standard_field.dart';
import 'package:vhome_repository/vhome_repository.dart';

class AddGroupPage extends StatelessWidget {
  const AddGroupPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => AddGroupBloc(
          repository: context.read<VhomeRepository>()
        ),
        child: const AddGroupPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddGroupBloc, AddGroupState>(
          listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == FormzSubmissionStatus.success,
          listener: (context, state) => Navigator.of(context).pop()
        ),
        BlocListener<AddGroupBloc, AddGroupState>(
          listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == FormzSubmissionStatus.failure,
          listener: (context, state) => 
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text("Failed to add group!")
                )
              )
        ),
      ],
      child: const AddGroupView(),
    );
  }
}

class AddGroupView extends StatelessWidget {
  const AddGroupView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add group"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 1000,
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _NameField(),
                    const SizedBox(height: 25),
                    _ConfirmButton(),
                  ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddGroupBloc, AddGroupState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return StandardFormField(
          hintText: "group name",
          onChanged: (value) => context.read<AddGroupBloc>().add(AddGroupNameChanged(name: value)),
          errorText: state.name.displayError != null ? 'group name can not be empty' : null,
        );
      }
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  _ConfirmButton();

  @override
  Widget build(BuildContext context) {
    final state = context.select((AddGroupBloc bloc) => bloc.state);

    return state.status.isInProgress
        ? const CircularProgressIndicator()
        : ConfirmButton(
            onPressed: state.isValid
              ? () => context.read<AddGroupBloc>().add(const AddGroupSubmitted())
              : null,
            child: Text("Add group"),
          );
  }
}
