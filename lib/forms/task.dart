import 'package:flutter/material.dart';
import 'package:vhome_frontend/components/fields.dart';
import 'package:vhome_frontend/models/taskset.dart';
import 'package:vhome_frontend/service/task.dart';

class AddTask extends StatelessWidget {
  final TaskSet taskSet;
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  AddTask({
    required this.taskSet,
  });

  void add() async {
    await TaskService().add(taskSet.id, titleController.text, contentController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add task to ${taskSet.title}"),
      ),
      body: Center(
        child: SizedBox(
          width: 1000,
          child: Column(
            children: [
              const SizedBox(height: 25),
              StandardFormField(
                hintText: "Title",
                validator: (text) { return text; },
                controller: titleController,
                obscureText: false,
              ), 
              const SizedBox(height: 25),
              StandardFormField(
                hintText: "Content",
                validator: (text) { return text; },
                controller: contentController,
                obscureText: false,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () async { add(); Navigator.pop(context, true); },
                child: Text("Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
