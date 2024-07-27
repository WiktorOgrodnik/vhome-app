// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json, bool isGroupSelected) => User(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      token: json['token'] as String,
      isGroupSelected: isGroupSelected,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'token': instance.token,
    };
