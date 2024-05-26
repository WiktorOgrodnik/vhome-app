import 'package:flutter/material.dart';
import 'package:vhome_frontend/forms/task.dart';
import 'package:vhome_frontend/models/task.dart';
import 'package:vhome_frontend/models/taskset.dart';
import 'package:vhome_frontend/service/task.dart';
import 'package:vhome_frontend/service/taskset.dart';
import 'package:vhome_frontend/views/task.dart';

class TaskSetView extends StatefulWidget {
  final TaskSet taskSet;

  const TaskSetView ({
    super.key,
    required this.taskSet,
  });

  @override
    State<StatefulWidget> createState() => TaskSetViewState();
}

class TaskSetViewState extends State<TaskSetView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    Future<List<Task>> futureTasks = TaskService().getTasks(widget.taskSet.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskSet.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: SizedBox(
          width: 1000,
          child: FutureBuilder<List<Task>>(
            future: futureTasks,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Expanded(
                      flex: 8,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            child: TaskListTile(
                              task: snapshot.data![index],
                              editable: true,
                              refreshTaskSet: () {
                                print("Refreshing");
                                setState(() {
                                  futureTasks = TaskService().getTasks(widget.taskSet.id);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddTask(taskSet: widget.taskSet)),
                            ).then((_) => setState(() {
                              futureTasks = TaskService().getTasks(widget.taskSet.id);
                            }));
                          },
                          child: Center(
                            child: Text("Add task"),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
        ),
      ),
    );
  }
}
class TaskTileDetails extends StatefulWidget {
  final int taskSetId;

  TaskTileDetails({
    required this.taskSetId,
  });
  
  @override
    State<StatefulWidget> createState() => TaskTileDetailsState();
}

class TaskTileDetailsState extends State<TaskTileDetails> {

  late Future<List<Task>> tasks;

  @override
  void initState() {
    super.initState();
    tasks = TaskService().getTasks(widget.taskSetId, limit: 3);
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<Task>>(
      future: tasks,
      builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Column(
          children: <Widget>[
            for (var task in snapshot.data!)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: TaskListTile(
                  task: task,
                  editable: false,
                  refreshTaskSet: () {},
                ),
              ),
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class TaskTile extends StatefulWidget {
  final TaskSet taskSet;

  const TaskTile({
    required this.taskSet,
  });

  @override
  State<StatefulWidget> createState() => TaskTileState();
}

class TaskTileState extends State<TaskTile> {
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );

    var styleSubText = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );

    int taskSetId = widget.taskSet.id;
    TaskTileDetails taskTileDetails = TaskTileDetails(
      taskSetId: taskSetId,
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
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          width: 400,
          height: 600,
          child: AnimatedSize(
            duration: Duration(milliseconds: 200),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.taskSet.title,
                    style: style,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "Recent changes:",
                      style: styleSubText,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: taskTileDetails,
                  ),
                  const Spacer(flex: 2),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TaskSetView(taskSet: widget.taskSet))
                        ).then((_) => setState(() {
                          taskSetId = widget.taskSet.id; 
                        }));
                      },
                      child: const Center(
                        child: Text("More..."),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TaskSetsView extends StatefulWidget {
  @override
    State<StatefulWidget> createState() => TaskSetsViewState();
}

class TaskSetsViewState extends State<TaskSetsView> {
  
  late Future<List<TaskSet>> futureLists;

  @override
  void initState() {
    super.initState();
    futureLists = TaskSetService().getTaskSets();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: FutureBuilder<List<TaskSet>>(
        future: futureLists,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Wrap(
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
        },
      ),
    ); 
  }
}

