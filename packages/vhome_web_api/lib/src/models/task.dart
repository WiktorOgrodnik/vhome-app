import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vhome_web_api/src/models/json_map.dart';

part 'task.g.dart';

@JsonSerializable()
class Task extends Equatable {
  const Task({
    this.id = 0,
    required this.title,
    required this.content,
    this.completed = false,
    required this.tasksetId,
    required this.taskAssigned,
  });

  factory Task.fromJson(JsonMap json) =>
    _$TaskFromJson(json);

  JsonMap toJson() => _$TaskToJson(this);

  final int id;
  final String title;
  final String content;
  final bool completed;
  @JsonKey(name: 'users_id')
  final List<int> taskAssigned;
  @JsonKey(name: 'taskset_id')
  final int tasksetId;

  Task copyWith({
    int? id,
    String? title,
    String? content,
    bool? completed,
    int? tasksetId,
    List<int>? taskAssigned,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      completed: completed ?? this.completed,
      tasksetId: tasksetId ?? this.tasksetId,
      taskAssigned: taskAssigned ?? this.taskAssigned,
    );
  }

  @override
  List<Object> get props => [id, title, content, completed, taskAssigned, tasksetId]; 
}
