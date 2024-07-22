import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/taskset_details/taskset_details.dart';

class TasksetDetailsList extends StatelessWidget {
  const TasksetDetailsList({
    super.key,
    this.summary = false,
  });
  
  final bool summary;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksetDetailsBloc, TasksetDetailsState>(
      builder: (context, state) {
        switch (state.status) {
          case TasksetDetailsStatus.failure:
            return const Text("failed to fetch tasks.");
          case TasksetDetailsStatus.success:
            return state.tasks.isEmpty ?
              const Center(child: Text("No tasks yet.")) :
              ListView.builder(
                itemCount: summary ? min(state.tasks.length, 3) : state.tasks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: TaskStandardTile(
                      task: state.tasks[index],
                      editable: !summary,
                    ),
                  );
                }
              );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}
