import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vhome_frontend/service/taskset.dart';
import 'package:vhome_frontend/views/taskset.dart';

class TaskSetsPage extends StatefulWidget {
  @override
  TaskSetsPageState createState() => TaskSetsPageState();
}

class TaskSetsPageState extends State<TaskSetsPage> {

  @override
  void initState() {
    super.initState();
    Provider.of<TaskSetService>(context, listen: false).fetchTaskSets();
  }

  @override
  Widget build(BuildContext context) {
    final taskSetService = Provider.of<TaskSetService>(context);
    return Scaffold(
      body: taskSetService.loading ?
        CircularProgressIndicator() :
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Wrap(
            children: [
              for (var taskSet in taskSetService.tasksets)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TaskTile(taskSet: taskSet),
                ),
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          taskSetService.fetchTaskSets();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}

