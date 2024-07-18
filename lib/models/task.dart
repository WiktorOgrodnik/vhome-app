import 'package:flutter/foundation.dart';

class Task with ChangeNotifier {
  int id;
  String title;
  String content;
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.content,
    required this.completed
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      completed: json['completed'],
    );
  }
}
