import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/add_task/bloc/add_task_bloc.dart';
import 'package:vhome_frontend/widgets/widgets.dart';
import 'package:vhome_repository/vhome_repository.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({required this.taskset, super.key});

  final Taskset taskset;

  static Route<void> route(Taskset taskset) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => AddTaskBloc(
          repository: context.read<VhomeRepository>(),
          taskset: taskset,
        ),
        child: AddTaskPage(taskset: taskset),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddTaskBloc, AddTaskState>(
      listenWhen: (previous, current) =>
        previous.status != current.status &&
        current.status == AddTaskStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: AddTaskView(taskset: taskset),
    );
  }
}

class AddTaskView extends StatelessWidget {
  const AddTaskView({required this.taskset, super.key});

  final Taskset taskset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add task to ${taskset.title}"),
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
                    _TitleField(),
                    _ContentField(),
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

class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    return StandardField2(
      hintText: "Title",
      onChanged: (value) {
        context.read<AddTaskBloc>().add(AddTaskTitleChanged(title: value));
      },
    );
  }
}

class _ContentField extends StatelessWidget {
  const _ContentField();

  @override
  Widget build(BuildContext context) {
    return StandardField2(
      hintText: "Content",
      onChanged: (value) {
        context.read<AddTaskBloc>().add(AddTaskContentChanged(content: value));
      },
    );
  }
}


class _AcceptButton extends StatelessWidget {
  const _AcceptButton();

  @override
  Widget build(BuildContext context) {
    final status = context.select((AddTaskBloc bloc) => bloc.state.status);

    return ElevatedButton(
      onPressed: status == AddTaskStatus.initial ?
        () => context.read<AddTaskBloc>().add(const AddTaskSubmitted())
        : null,
      child: Text("Add"),
    );
  }
}
