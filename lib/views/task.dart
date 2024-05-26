import 'package:flutter/material.dart';
import 'package:vhome_frontend/models/task.dart';
import 'package:vhome_frontend/service/task.dart';


class TaskListTile extends StatefulWidget {
  final Task task;
  final bool editable;
  final Function refreshTaskSet;

  const TaskListTile ({
    required this.task,
    required this.editable,
    required this.refreshTaskSet,
  });

  @override
  State<StatefulWidget> createState() => TaskListTileState();
}

class TaskListTileState extends State<TaskListTile> {
  var completed = false;

  @override void initState() {
    super.initState();
    completed = widget.task.completed;
  }

  void taskDelete(int taskId) async {
    var res = await TaskService().delete(taskId);
    print("Delete: $res");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const borderRadius = BorderRadius.all(Radius.circular(8));

    return Material(
      elevation: 4,
      borderRadius: borderRadius,
      child: ListTile(
        leading: widget.editable ? Checkbox(
          value: completed,
          onChanged: (bool? val) async {
            var res = await TaskService().changeCompleted(val!, widget.task.id);

            if (res == 200) {
              completed = !completed;
              setState(() {});
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Failed to change state: $res")),
              );
            }
          }
        ) : null,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        title: Text(
          widget.task.title,
          style: completed ? TextStyle(
            decoration: TextDecoration.lineThrough,
            decorationColor: theme.colorScheme.onPrimary,
          ) : null, 
        ),
        subtitle: Text(
          widget.task.content,
          style: completed ? TextStyle(
            decoration: TextDecoration.lineThrough,
            decorationColor: theme.colorScheme.onPrimary,
          ) : null,
        ),
        trailing: widget.editable ? IconButton(
          icon: Icon(
            Icons.delete,
            color: theme.colorScheme.onPrimary,
          ),
          onPressed: () {
            taskDelete(widget.task.id);
            setState(() {
              widget.refreshTaskSet(); 
            });
          }
        ) : Icon(Icons.abc) ,
        tileColor: theme.colorScheme.primary,
        textColor: theme.colorScheme.onPrimary,
      ),
    );
  }
}
