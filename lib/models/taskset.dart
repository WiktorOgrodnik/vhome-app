import 'package:flutter/foundation.dart';

class TaskSet with ChangeNotifier {
  int id;
  String title;

  TaskSet({
    required this.id,
    required this.title,
  });

  factory TaskSet.fromJson(Map<String, dynamic> json) {
    return TaskSet (
      id: json['id'],
      title: json['name'],
    );
  }
}



