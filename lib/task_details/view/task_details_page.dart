import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vhome_frontend/add_task/view/view.dart';
import 'package:vhome_frontend/task_details/bloc/task_details_bloc.dart';
import 'package:vhome_frontend/users/users.dart';
import 'package:vhome_frontend/widgets/section_title.dart';
import 'package:vhome_repository/vhome_repository.dart';

class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage(this.task);

  final Task task;

  static Route<void> route(Task task) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => TaskDetailsPage(task),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskDetailsBloc(
        repository: context.read<VhomeRepository>(),
        task: task
      )..add(TaskSubscriptionRequested()),
      child: const TaskDetailsListener(),
    );
  }
}

class TaskDetailsListener extends StatelessWidget {
  const TaskDetailsListener();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TaskDetailsBloc, TaskDetailsState>(
          listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == TaskDetailsStatus.deleted,
          listener: (context, state) => Navigator.of(context).pop(),
        ),
        BlocListener<TaskDetailsBloc, TaskDetailsState>(
          listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == TaskDetailsStatus.failure,
          listener: (context, state) =>
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text("Failed to load task!")
                )
              ),
          ),
      ],
      child: const TaskDetailsView(),
    );
  }
}

class TaskDetailsView extends StatelessWidget {
  const TaskDetailsView();

  @override
  Widget build(BuildContext context) {
    final display = context.read<VhomeRepository>().display;

    return BlocBuilder<TaskDetailsBloc, TaskDetailsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Task ${state.task.title} details"),
            actions: [
              if (!display)
              IconButton(
                onPressed: () =>
                  Navigator.of(context).push(
                    AddTaskPage.route(task: state.task)
                  ),
                tooltip: "Edit task",
                icon: const Icon(Icons.edit),
              ),
              if (!display)
              IconButton(
                onPressed: () =>
                  context
                    .read<TaskDetailsBloc>()
                    .add(TaskDeleted()),
                tooltip: "Delete task",
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 1200,
                    child: RefreshIndicator(
                      onRefresh: () async =>
                        context
                          .read<TaskDetailsBloc>()
                          .add(const TaskRefreshed()),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        child: Wrap(
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(minWidth: 300),
                              child: FractionallySizedBox(
                                widthFactor: constraints.maxWidth >= 745 ? 0.6 : 1.0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                              child: Transform.scale(
                                                scale: 1.2,
                                                child: Checkbox(
                                                  value: state.task.completed,
                                                  onChanged: (bool? val) =>
                                                    context
                                                      .read<TaskDetailsBloc>()
                                                      .add(TaskCompletionToggled(value: val!)),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: DefaultTextStyle(
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 35,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: state.task.completed
                                                        ? TextDecoration.lineThrough
                                                        : null,
                                                  ),
                                                  child: Text(state.task.title),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8.0),
                                        child: DefaultTextStyle(
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          child: Text("Task content:")
                                        ),
                                      ),
                                      SizedBox(
                                        width: 600,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Text(state.task.content),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8.0),
                                        child: DefaultTextStyle(
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          child: Text("Last updated: ${DateFormat('yyyy-MM-dd – kk:mm').format(state.task.lastUpdated.toLocal())}"),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(minWidth: 300.0),
                              child: FractionallySizedBox(
                                widthFactor: constraints.maxWidth > 745 ? 0.4 : 1.0,
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: SectionTitle(child: Text("Assigned users")),
                                    ),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxHeight: 800.0,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                                        child: BlocProvider(
                                          create: (context) => UsersBloc(repository: context.read<VhomeRepository>())
                                            ..add(const UsersSubscriptionRequested()),
                                          child: UsersList(editing: true)
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              );
            }
          ),
        );
      }
    );
  }
}
