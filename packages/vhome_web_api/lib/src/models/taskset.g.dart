// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taskset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Taskset _$TasksetFromJson(Map<String, dynamic> json) => Taskset(
      id: (json['id'] as num).toInt(),
      title: json['name'] as String,
    );

Map<String, dynamic> _$TasksetToJson(Taskset instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.title,
    };
