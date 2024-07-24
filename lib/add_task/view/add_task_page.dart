import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/add_task/bloc/add_task_bloc.dart';
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
      body: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 1000,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _TitleField(),
                      _ContentField(),
                      SizedBox(height: 25),
                      _AcceptButton(),
                    ]
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.hintText,
    required this.onChanged
  });
  
  final ValueChanged<String>? onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey),
        ),
        fillColor: Colors.grey.shade200,
        filled: true,
        hintText: hintText,
      ),
      onChanged: onChanged,
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    return _Field(
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
    return _Field(
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
