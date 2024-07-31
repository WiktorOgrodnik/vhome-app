// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthModel _$AuthModelFromJson(Map<String, dynamic> json, bool isGroupSelected) => AuthModel(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      token: json['token'] as String,
      picture: const Uint8ListConverter().fromJson(json['picture']),
      isGroupSelected: isGroupSelected,
    );

Map<String, dynamic> _$AuthModelToJson(AuthModel instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'token': instance.token,
      'isGroupSelected': instance.isGroupSelected,
      'picture': const Uint8ListConverter().toJson(instance.picture),
    };
