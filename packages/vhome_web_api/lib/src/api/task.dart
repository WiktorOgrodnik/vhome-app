import 'dart:convert';
import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:vhome_web_api/vhome_web_api.dart';
import 'package:http/http.dart' as http;

class TaskApi {
  const TaskApi();

  Future<Map<int, Task>?> _fetchTasks(String token, int tasksetId) async {
    final uri = Uri.parse("$apiUrl/tasks/$tasksetId");
    final response = await http.get(uri, headers: {'Authorization': token} );
    final List<dynamic> responseData = response.statusCode == HttpStatus.ok ?
      jsonDecode(utf8.decode(response.bodyBytes)) : [];

    final data = responseData.map((x) => Task.fromJson(x)); 

    return { for (var v in data) v.id: v };
  }

  Future<List<Task>> getTasks(String token, int tasksetId, {int? limit}) async {
    final tasks = await _fetchTasks(token, tasksetId);
    final Map<int, Task> data = tasks ?? {};
    final iter = data.entries.map((x) => x.value);
    
    return limit == null ? iter.toList() : iter.take(limit).toList();
  }

  Future<void> changeCompleted(String token, Task task, bool value) async {
    final uri = value ? 
      Uri.parse("$apiUrl/task/${task.id}/completed") :
      Uri.parse("$apiUrl/task/${task.id}/uncompleted");

    final response = await http.put(uri, headers: {'Authorization': token} );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception("Cannot toggle completition of the task");
    }
  }

  Future<void> add(String token, int tasksetId, String title, String content) async {
    final uri = Uri.parse("$apiUrl/tasks");
    final payload = jsonEncode({ "taskset_id": tasksetId, "title": title, "content": content });

    final response = await http.post(
      uri,
      headers: {
        'Authorization': token,
        'Accept': 'application/json',
        'content-type': 'application/json',
      },
      body: payload
    );

    if (response.statusCode != HttpStatus.created) {
      throw Exception("Can not add the task");
    }
  }

  Future<void> delete(String token, Task task) async {
    final uri = Uri.parse("$apiUrl/task/${task.id}");

    final response = await http.delete(uri, headers: {'Authorization': token});

    if (response.statusCode != HttpStatus.ok) {
      throw Exception("Can not deleted the task");
    }
  }
}
