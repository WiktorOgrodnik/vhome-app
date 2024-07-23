import 'package:flutter/material.dart';
import 'package:vhome_frontend/taskset_details/taskset_details.dart';
import 'package:vhome_frontend/tasksets_page/tasksets_page.dart';
import 'package:vhome_repository/vhome_repository.dart';

class TasksetTile extends StatelessWidget {
  const TasksetTile({required this.taskset, super.key});

  final Taskset taskset;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );

    var styleSubText = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
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
                    taskset.title,
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
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: TasksetTasksSummary(taskset: taskset),
                  ),
                  const Spacer(flex: 2),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.of(context).push(
                          TasksetDetailsPage.route(taskset)
                        );
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
