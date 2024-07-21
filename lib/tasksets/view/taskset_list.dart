import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/tasksets/tasksets_page.dart';

class TasksetList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksetsBloc, TasksetsState> (
      builder: (context, state) {
        switch (state.status) {
          case TasksetsStatus.failure:
            return const Center(child: Text("failed to fetch tasksets"));
          case TasksetsStatus.success:
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                children: [
                  for (var taskset in state.tasksets)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: TasksetTile(taskset: taskset),
                    ),
                ],
              ),
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
