import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:vhome_web_api/vhome_web_api.dart';
import 'package:http/http.dart' as http;

class TasksetApi {
  TasksetApi();

  final _tasksetOutdated = BehaviorSubject<void>.seeded(null);

  Stream<void> tasksetOutdated() => _tasksetOutdated.asBroadcastStream();
  Stream<List<Taskset>> getTasksets(String token) => 
    _tasksetOutdated.switchMap((_) => Stream.fromFuture(fetchTasksets(token))).asBroadcastStream();

  Future<List<Taskset>> fetchTasksets(String token) async {
    final uri = Uri.parse("$apiUrl/tasksets");
    final response = await http.get(uri, headers: { 'Authorization': token } );
    
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Can not get the Tasksets');
    }

    final List<dynamic> responseData = jsonDecode(response.body);
    final List<Taskset> fetchedTaskSets = responseData.map((taskset) => Taskset.fromJson(taskset)).toList();

    return fetchedTaskSets; 
  }

  Future<void> addTaskset(String token, String name) async {
    final uri = Uri.parse("$apiUrl/tasksets");
    final payload = jsonEncode({ "name": name, });

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
      throw Exception("g");
    }

    _tasksetOutdated.add(null);
  }

  Future<void> deleteTaskset(String token, Taskset taskset) async {
    final uri = Uri.parse("$apiUrl/taskset/${taskset.id}");
    final response = await http.delete(uri, headers: { 'Authorization': token });

    if (response.statusCode != HttpStatus.ok) {
      throw Exception("g");
    }

    _tasksetOutdated.add(null);
  }

}
