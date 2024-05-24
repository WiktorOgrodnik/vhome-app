import 'package:flutter/material.dart';
import 'package:vhome_frontend/models/task.dart';
import 'package:vhome_frontend/models/taskset.dart';
import 'package:vhome_frontend/service/task.dart';
import 'package:vhome_frontend/service/taskset.dart';

class TaskTileDetails extends StatefulWidget {
  final int taskSetId;

  TaskTileDetails({
    required this.taskSetId,
  });
  
  @override
    State<StatefulWidget> createState() => TaskTileDetailsState();
}

class TaskTileDetailsState extends State<TaskTileDetails> {
  
  late Future<List<Task>> futureTasks;

  @override
  void initState() {
    super.initState();
    futureTasks = TaskService().getTasks(widget.taskSetId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: futureTasks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              for (var task in snapshot.data!)
                Container(
                  height: 50,
                  color: Colors.amber[600],
                  child: Center(child: Text(task.title)),
                ),
            ],
          );
          // return Column(
          //   children: [
          //     for (var task in snapshot.data!)
          //     Padding(
          //       padding: EdgeInsets.all(20),
          //       child: 
          //     )
          //   ],
          // );
        } else {
          return CircularProgressIndicator();
        }
      } 
    );
  }
}

class TaskTile extends StatelessWidget {
  final TaskSet taskSet;

  const TaskTile({
    required this.taskSet,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onSecondary,
    );

    var styleSubText = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onSecondary,
    );
 

    return Material(
      elevation: 4,
      color: Colors.transparent,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          width: 250,
          height: 340,
          child: AnimatedSize(
            duration: Duration(milliseconds: 200),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(taskSet.title, style: style),
                  Text("Recent changes:", style: styleSubText),
                  TaskTileDetails(taskSetId: taskSet.id),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TaskSetView extends StatefulWidget {
  @override
    State<StatefulWidget> createState() => TaskSetViewState();
}

class TaskSetViewState extends State<TaskSetView> {
  
  late Future<List<TaskSet>> futureLists;

  @override
  void initState() {
    super.initState();
    futureLists = TaskSetService().getTaskSets();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TaskSet>>(
      future: futureLists,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: [
              for (var taskSet in snapshot.data!)
              Padding(
                padding: EdgeInsets.all(20),
                child: TaskTile(taskSet: taskSet),
              )
            ],
          );
        } else {
          return Placeholder();
        }
      } 
    );
  }
}


