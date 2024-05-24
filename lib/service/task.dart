import 'dart:async';

import 'package:vhome_frontend/models/task.dart';
import 'package:vhome_frontend/service/service.dart';

class TaskService extends Service {
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  Future<List<Task>> getTasks(int taskSetId) async {
    var data = await Service.getDataList("tasks/$taskSetId");
    return data.map((x) => Task.fromJson(x)).toList();
  }
}
