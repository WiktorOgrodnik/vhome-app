import 'dart:async';

import 'package:vhome_frontend/models/taskset.dart';
import 'package:vhome_frontend/service/service.dart';

class TaskSetService extends Service {
  static final TaskSetService _instance = TaskSetService._internal();
  factory TaskSetService() => _instance;
  TaskSetService._internal();

  final _taskSetController = StreamController<TaskSet>();

  Stream<TaskSet> get taskSetsOutdated$ => _taskSetController.stream;

  Future<List<TaskSet>> getTaskSets() async {
    var data = await Service.getDataList("lists");
    return data.map((x) => TaskSet.fromJson(x)).toList();
  }
}
