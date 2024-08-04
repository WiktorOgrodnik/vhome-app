import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/taskset_details/taskset_details.dart';
import 'package:vhome_frontend/users/bloc/users_bloc.dart';
import 'package:vhome_repository/vhome_repository.dart';


class TasksetDetailsPage extends StatelessWidget {
  const TasksetDetailsPage ({required this.taskset, super.key});

  final Taskset taskset;
  
  static Route<void> route(Taskset taskset) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => TasksetDetailsPage(taskset: taskset),
    );
  }

  @override
    Widget build(BuildContext context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => 
            TasksetDetailsBloc(repository: context.read<VhomeRepository>(), taskset: taskset)
              ..add(TasksSubscriptionRequested())),
          BlocProvider(create: (context) =>
            UsersBloc(repository: context.read<VhomeRepository>())
              ..add(UsersSubscriptionRequested())),
        ],
        child: TasksetDetailsListener(taskset: taskset)
      );
    }
}

class TasksetDetailsListener extends StatelessWidget {
  const TasksetDetailsListener({required this.taskset, super.key});

  final Taskset taskset;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksetDetailsBloc, TasksetDetailsState>(
      listenWhen: (previous, current) =>
        previous.status != current.status &&
        current.status == TasksetDetailsStatus.deleted,
      listener: (context, state) => Navigator.of(context).pop(),
      child: TasksetDetailsView(taskset: taskset),
    );
  }
}

class TasksetDetailsView extends StatelessWidget {
  const TasksetDetailsView({required this.taskset, super.key});

  final Taskset taskset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(taskset.title),
        actions: [
          IconButton(
            onPressed: () {
              context
                .read<TasksetDetailsBloc>()
                .add(TasksetDeleted(taskset: taskset));
            },
            tooltip: "Delete taskset",
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: SizedBox(
            width: 1000,
            child: Column(
              children: [
                Expanded(
                  flex: 8,
                  child: TasksetDetailsList(),
                ),
                Expanded(
                  flex: 1,
                  child: TasksetDetailsAddTaskButton(taskset: taskset), 
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
