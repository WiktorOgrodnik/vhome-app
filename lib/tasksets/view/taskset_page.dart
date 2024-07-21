import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/add_taskset/view/view.dart';
import 'package:vhome_frontend/tasksets/bloc/tasksets_bloc.dart';
import 'package:vhome_frontend/tasksets/view/view.dart';
import 'package:vhome_repository/vhome_repository.dart';

class TasksetsPage extends StatelessWidget {
  const TasksetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TasksetsBloc(repository: context.read<VhomeRepository>())
        ..add(TasksetsSubscriptionRequested()),
      child: const TasksetsView(),   
    );
  }
}

class TasksetsView extends StatelessWidget {
  const TasksetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TasksetList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            AddTasksetPage.route(),
          );
        },
      ),
    );
  }
}
