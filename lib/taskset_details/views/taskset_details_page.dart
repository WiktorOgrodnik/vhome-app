import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/forms/task.dart';
import 'package:vhome_frontend/taskset_details/taskset_details.dart';
import 'package:vhome_repository/vhome_repository.dart';


class TasksetDetailsPage extends StatelessWidget {
  const TasksetDetailsPage ({required this.taskset, super.key});

  final Taskset taskset;
  
  static Route<void> route(Taskset taskset) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => TasksetDetailsBloc(
          repository: context.read<VhomeRepository>(),
          taskset: taskset
        )..add(TasksFetched()),
        child: TasksetDetailsPage(taskset: taskset),
      ),
    );
  }

  @override
    Widget build(BuildContext context) {
      return TasksetDetailsView(taskset: taskset);
    }
}

class TasksetDetailsView extends StatelessWidget {
  const TasksetDetailsView({required this.taskset, super.key});

  final Taskset taskset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(taskset.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: SizedBox(
            width: 1000,
            child: BlocBuilder<TasksetDetailsBloc, TasksetDetailsState>(
              builder: (context, state) {
                switch (state.status) {
                  case TasksetDetailsStatus.failure:
                    return const Text("failed to fetch tasks!");
                  case TasksetDetailsStatus.success:
                    return TasksetDetailsList();
                  default:
                    return const CircularProgressIndicator();
                }
              },
            ), 
          ),
        ),
      ),
    );
  }
}

class TasksetDetailsList extends StatelessWidget {
  const TasksetDetailsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksetDetailsBloc, TasksetDetailsState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              flex: 8,
              child: state.tasks.isEmpty ?
                const Center(child: Text("No tasks yet.")) :
                ListView.builder(
                  itemCount: state.tasks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: TaskStandardTile(
                        task: state.tasks[index],
                        editable: true
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
                      MaterialPageRoute(builder: (context) => AddTask(taskSet: state.taskset)),
                    ).then((_) => {});
                  },
                  child: Center(
                    child: Text("Add task"),
                  ),
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}
