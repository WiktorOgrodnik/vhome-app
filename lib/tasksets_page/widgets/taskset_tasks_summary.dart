import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/taskset_details/taskset_details.dart';
import 'package:vhome_repository/vhome_repository.dart';

class TasksetTasksSummary extends StatelessWidget {
  const TasksetTasksSummary({required this.taskset, super.key});

  final Taskset taskset;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TasksetDetailsBloc(
        repository: context.read<VhomeRepository>(),
        taskset: taskset,
      )..add(TasksSubscriptionRequested()),
      child: TasksetTasksSummaryView(),
    );
  }
}

class TasksetTasksSummaryView extends StatelessWidget {
  const TasksetTasksSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250.0,
      child: TasksetDetailsList(summary: true),
    );
  }
}

