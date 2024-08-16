import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vhome_web_api/src/models/json_map.dart';

part 'task.g.dart';

@JsonSerializable()
class Task extends Equatable {
  Task({
    this.id = 0,
    required this.title,
    required this.content,
    this.completed = false,
    this.tasksetId = 0,
    required this.taskAssigned,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

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
  @JsonKey(name: 'last_update')
  final DateTime lastUpdated;

  Task copyWith({
    int? id,
    String? title,
    String? content,
    bool? completed,
    int? tasksetId,
    List<int>? taskAssigned,
    DateTime? lastUpdated,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      completed: completed ?? this.completed,
      tasksetId: tasksetId ?? this.tasksetId,
      taskAssigned: taskAssigned ?? this.taskAssigned,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object> get props => [id, title, content, completed, taskAssigned, tasksetId, lastUpdated];
}
