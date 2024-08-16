// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String,
      content: json['content'] as String,
      completed: json['completed'] as bool? ?? false,
      tasksetId: (json['taskset_id'] as num?)?.toInt() ?? 0,
      taskAssigned: (json['users_id'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      lastUpdated: json['last_update'] == null
          ? null
          : DateTime.parse(json['last_update'] as String),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'completed': instance.completed,
      'users_id': instance.taskAssigned,
      'taskset_id': instance.tasksetId,
      'last_update': instance.lastUpdated.toIso8601String(),
    };
