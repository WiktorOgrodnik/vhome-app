import 'dart:async';
import 'dart:convert';

import 'package:vhome_frontend/consts/api_url.dart';
import 'package:vhome_frontend/models/task.dart';
import 'package:vhome_frontend/service/service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session_manager/flutter_session_manager.dart';

class TaskService {
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  Future<List<Task>> getTasks(int taskSetId, {int? limit}) async {
    var data = await Service.getDataList("tasks/$taskSetId", limit: limit);
    return data.map((x) => Task.fromJson(x)).toList();
  }

  Future<int> changeCompleted(bool val, int taskId) async {
    var uri = Uri.parse("$apiUrl/task/completed/$taskId/$val");
    var sid = await SessionManager().get('session.sid');
    var response = await http.put(uri, headers: {'cookie': sid} );

    return response.statusCode;
  }

  Future<int> add(int taskSetId, String title, String content) async {
    var uri = Uri.parse("$apiUrl/tasks/$taskSetId");
    var sid = await SessionManager().get('session.sid');
    var payload = jsonEncode({ "title": title, "content": content });

    var response = await http.post(uri, headers: {'cookie': sid}, body: payload);

    return response.statusCode;
  }

  Future<int> delete(int taskId) async {
    var uri = Uri.parse("$apiUrl/task/$taskId");
    var sid = await SessionManager().get('session.sid');

    var response = await http.delete(uri, headers: {'cookie': sid});

    return response.statusCode;
  }
}
