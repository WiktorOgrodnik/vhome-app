// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      createdTime: DateTime.parse(json['createdTime'] as String),
      picture: const Uint8ListConverter().fromJson(json['picture']),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'createdTime': instance.createdTime.toIso8601String(),
      'picture': const Uint8ListConverter().toJson(instance.picture),
    };
