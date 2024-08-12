import 'dart:convert';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:vhome_web_api/vhome_web_api.dart';
import 'package:http/http.dart' as http;

class TaskApi {
  TaskApi();

  final _tasksOutdated$ = BehaviorSubject<void>.seeded(null);

  Stream<void> get tasksOutdated$ => _tasksOutdated$.asBroadcastStream();
  Stream<List<Task>> getTasks(String token, int tasksetId, {int? limit}) =>
    _tasksOutdated$.switchMap((_) => 
      Stream.fromFuture(_fetchTasks(token, tasksetId))).asBroadcastStream();

  Future<Task> _taskFromJsonWithAssigns(String token, JsonMap taskMap) async {
    final id = taskMap['id'];
    final uri = Uri.parse("$apiUrl/task/$id/assign");
    final response = await http.get(uri, headers: { 'Authorization': token });

    final JsonMap responseData = response.statusCode == HttpStatus.ok 
        ? jsonDecode(response.body)
        : {};

    responseData.addAll(taskMap);
    return Task.fromJson(responseData);
  }

  Future<List<Task>> _fetchTasks(String token, int tasksetId) async {
    final uri = Uri.parse("$apiUrl/tasks/$tasksetId");
    final response = await http.get(uri, headers: {'Authorization': token} );
    final List<dynamic> responseData = response.statusCode == HttpStatus.ok ?
      jsonDecode(utf8.decode(response.bodyBytes)) : [];

    return Future.wait(responseData.map((x) => _taskFromJsonWithAssigns(token, x))); 
  }

  Future<void> changeCompleted(String token, Task task, bool value) async {
    final uri = value ? 
      Uri.parse("$apiUrl/task/${task.id}/completed") :
      Uri.parse("$apiUrl/task/${task.id}/uncompleted");

    final response = await http.put(uri, headers: { 'Authorization': token });

    if (response.statusCode != HttpStatus.ok) {
      throw Exception("Cannot toggle completition of the task");
    }

    _tasksOutdated$.add(null);
  }

  Future<void> changeAssign(String token, int task, User user, bool value) async {
    final uri = value ? 
      Uri.parse("$apiUrl/task/$task/assign/${user.id}") :
      Uri.parse("$apiUrl/task/$task/unassign/${user.id}");

    final response = await http.put(uri, headers: { 'Authorization': token });

    if (response.statusCode != HttpStatus.ok) {
      throw Exception("Cannot toggle assign of the task");
    }

    _tasksOutdated$.add(null);
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

    _tasksOutdated$.add(null);
  }

  Future<void> edit(String token, Task task) async {
    final uri = Uri.parse("$apiUrl/task/${task.id}");
    final payload = jsonEncode({ "title": task.title, "content": task.content });

    final response = await http.patch(
      uri,
      headers: {
        'Authorization': token,
        'Accept': 'application/json',
        'content-type': 'application/json',
      },
      body: payload
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception("Can not edit task");
    }

    _tasksOutdated$.add(null);
  }

  Future<void> delete(String token, Task task) async {
    final uri = Uri.parse("$apiUrl/task/${task.id}");

    final response = await http.delete(uri, headers: {'Authorization': token});

    if (response.statusCode != HttpStatus.ok) {
      throw Exception("Can not deleted the task");
    }

    _tasksOutdated$.add(null);
  }

  void refreshTasks() {
    _tasksOutdated$.add(null);
  }
}
