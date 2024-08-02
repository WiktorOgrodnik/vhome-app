import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:vhome_frontend/add_task/bloc/add_task_bloc.dart';
import 'package:vhome_frontend/users/bloc/users_bloc.dart';
import 'package:vhome_frontend/users/view/view.dart';
import 'package:vhome_frontend/widgets/widgets.dart';
import 'package:vhome_repository/vhome_repository.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({this.taskset, this.task, super.key}) : 
    assert((taskset != null && task == null) || (taskset == null && task != null));

  final Taskset? taskset;
  final Task? task;

  static Route<void> route({Taskset? taskset, Task? task}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => AddTaskBloc(
          repository: context.read<VhomeRepository>(),
          taskset: taskset,
          task: task,
        ),
        child: AddTaskPage(taskset: taskset, task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddTaskBloc, AddTaskState>(
          listenWhen: (previous, current) =>
            previous.formStatus != current.formStatus &&
            current.formStatus.isSuccess,
          listener: (context, state) => Navigator.of(context).pop(),
        ),
        BlocListener<AddTaskBloc, AddTaskState>(
          listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == AddDeviceStatus.deleted,
          listener: (context, state) => Navigator.of(context).pop(),
        ),
        BlocListener<AddTaskBloc, AddTaskState>(
          listenWhen: (previous, current) =>
            previous.formStatus != current.formStatus &&
            current.formStatus.isFailure,
          listener: (context, state) => 
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text("Failed to add/edit task!")
                )
              )
        ),
      ],
      child: AddTaskView(taskset: taskset, task: task),
    );
  }
}

class AddTaskView extends StatelessWidget {
  const AddTaskView({this.taskset, this.task, super.key}) :
    assert((taskset != null && task == null) || (taskset == null && task != null));

  final Taskset? taskset;
  final Task? task;

  bool get editable => taskset == null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: editable
          ? Text("Editing task ${task!.title}")
          : Text("Add task to ${taskset!.title}"),
        actions: [
          if (editable)
            IconButton(
              onPressed: () {
                context
                  .read<AddTaskBloc>()
                  .add(TaskDeleted(task: task!));
              },
              tooltip: "Delete task",
              icon: const Icon(Icons.delete),
            ),
        ],
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
                    _TitleField(initialValue: editable ? task!.title : null),
                    SizedBox(height: 25),
                    _ContentField(initialValue: editable ? task!.content : null),
                    if (editable) 
                    SizedBox(height: 25),
                    if (editable) 
                    _AssignMultiSelect(task: task!),
                    SizedBox(height: 25),
                    _AcceptButton(editable),
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
  const _TitleField({this.initialValue});

  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTaskBloc, AddTaskState>(
      buildWhen: (previous, current) => previous.title != current.title,
      builder: (context, state) {
        return StandardFormField(
          initialValue: initialValue,
          hintText: "Title",
          onChanged: (value) => context.read<AddTaskBloc>().add(AddTaskTitleChanged(title: value)),
          errorText: state.title.displayError != null ? 'task title can not be null' : null,
        );
      }
    );
  }
}

class _ContentField extends StatelessWidget {
  const _ContentField({this.initialValue});

  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTaskBloc, AddTaskState>(
      buildWhen: (previous, current) => previous.content != current.content,
      builder: (context, state) {
        return StandardFormField(
          initialValue: initialValue,
          hintText: "Content",
          onChanged: (value) => context.read<AddTaskBloc>().add(AddTaskContentChanged(content: value)),
          errorText: state.content.displayError != null ? 'task content can not be null' : null,
        );
      }
    );
  }
}

class _AssignMultiSelect extends StatelessWidget {
  const _AssignMultiSelect({required this.task});
  
  final Task task;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTaskBloc, AddTaskState>(
      buildWhen: (previous, current) => previous.content != current.content,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => UsersBloc(repository: context.read<VhomeRepository>())
            ..add(UsersSubscriptionRequested()),
          child: SizedBox(
            height: 400,
            child: UsersList(task: task),
          ),
        );
      }
    );
  }
}

class _AcceptButton extends StatelessWidget {
  const _AcceptButton(this.editable);

  final bool editable;

  @override
  Widget build(BuildContext context) {
    final state = context.select((AddTaskBloc bloc) => bloc.state);

    return state.formStatus.isInProgress
        ? const CircularProgressIndicator()
        : ConfirmButton(
            onPressed: state.isValid 
              ? () => context.read<AddTaskBloc>().add(const AddTaskSubmitted())
              : null,
            child: editable 
              ? Text("Edit task")
              : Text("Add task"),
          );
  }
}
