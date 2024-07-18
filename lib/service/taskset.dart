import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import 'package:vhome_frontend/consts/api_url.dart';
import 'package:vhome_frontend/models/taskset.dart';

class TaskSetService with ChangeNotifier {
  late List<TaskSet> _tasksets;
  List<TaskSet> get tasksets => _tasksets;

  bool loading = true;
  
  Future<void> fetchTaskSets() async {
    try {
      loading = true;
      final uri = Uri.parse("$apiUrl/tasksets");
      final token = await SessionManager().get("user.token");
      final response = await http.get(uri, headers: { 'Authorization': token } );
      final List<dynamic> responseData = jsonDecode(response.body);
      print(responseData);
      final List<TaskSet> fetchedTaskSets = responseData.map((taskset) => TaskSet.fromJson(taskset)).toList();

      _tasksets = fetchedTaskSets; 

      loading = false;
      notifyListeners();
    } catch (error) {
      print("Catchy: $error");
    }
  }
}
