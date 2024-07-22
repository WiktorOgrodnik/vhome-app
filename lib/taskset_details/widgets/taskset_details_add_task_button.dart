import 'package:flutter/material.dart';
import 'package:vhome_frontend/add_task/view/view.dart';
import 'package:vhome_repository/vhome_repository.dart';

class TasksetDetailsAddTaskButton extends StatelessWidget {
  const TasksetDetailsAddTaskButton({required this.taskset, super.key});
  
  final Taskset taskset;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await Navigator.of(context).push(
          AddTaskPage.route(taskset)
        );
      },
      child: Center(
        child: Text("Add task"),
      ),
    );
  }
}
