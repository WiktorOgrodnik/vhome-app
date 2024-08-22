import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:vhome_frontend/add_taskset/bloc/add_taskset_bloc.dart';
import 'package:vhome_frontend/widgets/confirm_button.dart';
import 'package:vhome_frontend/widgets/standard_field.dart';
import 'package:vhome_repository/vhome_repository.dart';

class AddTasksetPage extends StatelessWidget {
  const AddTasksetPage({super.key, this.taskset});

  final Taskset? taskset;

  static Route<void> route({Taskset? taskset}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => AddTasksetBloc(
          repository: context.read<VhomeRepository>(),
          taskset: taskset,
        ),
        child: AddTasksetPage(taskset: taskset),
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
      child: AddTasksetView(taskset: taskset),
    );
  }
}

class AddTasksetView extends StatelessWidget {
  const AddTasksetView({super.key, this.taskset});

  final Taskset? taskset;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: taskset == null 
                ? const Text("Add taskset")
                : Text("Edit ${taskset!.title}")
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
                    _NameField(initialValue: taskset?.title),
                    const SizedBox(height: 25),
                    _ConfirmButton(edit: taskset != null),
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
  const _NameField({this.initialValue});

  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTasksetBloc, AddTasksetState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return StandardFormField(
          initialValue: initialValue,
          hintText: "Taskset name",
          onChanged: (value) => context.read<AddTasksetBloc>().add(AddTasksetNameChanged(name: value)),
          errorText: state.name.displayError != null ? 'taskset name can not be empty' : null,
        );
      }
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({this.edit = false});

  final bool edit;

  @override
  Widget build(BuildContext context) {
    final state = context.select((AddTasksetBloc bloc) => bloc.state);

    return state.status.isInProgress
        ? const CircularProgressIndicator()
        : ConfirmButton(
            onPressed: state.isValid
              ? () => context.read<AddTasksetBloc>().add(const AddTasksetSubmitted())
              : null,
            child: edit
              ? Text("Edit taskset")
              : Text("Add taskset")
          );
  }
}
