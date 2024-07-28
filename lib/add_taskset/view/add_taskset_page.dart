import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:vhome_frontend/add_taskset/bloc/add_taskset_bloc.dart';
import 'package:vhome_frontend/widgets/confirm_button.dart';
import 'package:vhome_frontend/widgets/standard_field.dart';
import 'package:vhome_repository/vhome_repository.dart';

class AddTasksetPage extends StatelessWidget {
  const AddTasksetPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => AddTasksetBloc(
          repository: context.read<VhomeRepository>()
        ),
        child: const AddTasksetPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddTasksetBloc, AddTasksetState>(
          listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == FormzSubmissionStatus.success,
          listener: (context, state) => Navigator.of(context).pop()
        ),
        BlocListener<AddTasksetBloc, AddTasksetState>(
          listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == FormzSubmissionStatus.failure,
          listener: (context, state) => 
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text("Failed to add taskset!")
                )
              )
        ),
      ],
      child: const AddTasksetView(),
    );
  }
}

class AddTasksetView extends StatelessWidget {
  const AddTasksetView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add taskset"),
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
    return BlocBuilder<AddTasksetBloc, AddTasksetState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return StandardFormField(
          hintText: "Taskset name",
          onChanged: (value) => context.read<AddTasksetBloc>().add(AddTasksetNameChanged(name: value)),
          errorText: state.name.displayError != null ? 'taskset name can not be empty' : null,
        );
      }
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  _ConfirmButton();

  @override
  Widget build(BuildContext context) {
    final state = context.select((AddTasksetBloc bloc) => bloc.state);

    return state.status.isInProgress
        ? const CircularProgressIndicator()
        : ConfirmButton(
            onPressed: state.isValid
              ? () => context.read<AddTasksetBloc>().add(const AddTasksetSubmitted())
              : null,
            child: Text("Add taskset"),
          );
  }
}
