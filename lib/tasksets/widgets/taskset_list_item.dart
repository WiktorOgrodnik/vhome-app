import 'package:flutter/material.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

class TasksetListItem extends StatelessWidget {
  const TasksetListItem({required this.taskset, super.key});

  final Taskset taskset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const borderRadius = BorderRadius.all(Radius.circular(8));

    return Material(
      elevation: 4,
      borderRadius: borderRadius,
      child: ListTile(
        leading: null,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        title: Text(taskset.title),
        tileColor: theme.colorScheme.primary,
        textColor: theme.colorScheme.onPrimary,
      ),
    );
  }
}

