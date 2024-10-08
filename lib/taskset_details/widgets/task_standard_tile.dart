import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/task_details/view/view.dart';
import 'package:vhome_frontend/taskset_details/bloc/taskset_details_bloc.dart';
import 'package:vhome_frontend/users/users.dart';
import 'package:vhome_frontend/widgets/widgets.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

class TaskStandardTile extends StatelessWidget {
  final Task task;
  final bool editable;

  const TaskStandardTile ({
    required this.task,
    required this.editable,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const borderRadius = BorderRadius.all(Radius.circular(8));

    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        return Material(
          elevation: 4,
          borderRadius: borderRadius,
          child: ListTile(
            leading: editable ? Checkbox(
              value: task.completed,
              onChanged: (bool? val) {
                context
                  .read<TasksetDetailsBloc>()
                  .add(TaskCompletionToggled(task: task, value: val!));
              }
            ) : null,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            title: Text(
              task.title,
              style: task.completed ? TextStyle(
                decoration: TextDecoration.lineThrough,
                decorationColor: theme.colorScheme.onPrimary,
              ) : null, 
            ),
            subtitle: Text(
              task.content.length > 70 ? '${task.content.substring(0, 70)}...' : task.content,
              style: task.completed ? TextStyle(
                decoration: TextDecoration.lineThrough,
                decorationColor: theme.colorScheme.onPrimary,
              ) : null,
            ),
            trailing: UserAssignMultiIcon(taskAssignes: task.taskAssigned),
            tileColor: task.completed ? theme.colorScheme.secondary : theme.colorScheme.primary,
            textColor: theme.colorScheme.onPrimary,
            onTap: () => 
              Navigator.of(context).push(
                TaskDetailsPage.route(task)
              ),
          ),
        );
      }
    );
  }
}
