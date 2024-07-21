import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/add_taskset/bloc/add_taskset_bloc.dart';
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
    return BlocListener<AddTasksetBloc, AddTasksetState>(
      listenWhen: (previous, current) =>
        previous.status != current.status &&
        current.status == AddTasksetStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const AddTasksetView(),
    );
  }
}

class AddTasksetView extends StatelessWidget {
  const AddTasksetView({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((AddTasksetBloc bloc) => bloc.state.status);

    return Scaffold(
      appBar: AppBar(
        title: Text("Add taskset"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: status == AddTasksetStatus.initial ?
          () => context.read<AddTasksetBloc>().add(const AddTasksetSubmitted()) :
          null,
      ),
      body: const Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [_NameField()]
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
    return TextFormField(
      onChanged: (value) {
        context.read<AddTasksetBloc>().add(AddTasksetNameChanged(name: value));
      },
    );
  }
}
