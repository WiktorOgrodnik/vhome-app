import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vhome_web_api/src/models/models.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends Equatable {
  const User({
    required this.id,
    required this.username,
    required this.createdTime,
    required this.picture,
  });
  
  factory User.fromJson(JsonMap json) 
    => _$UserFromJson(json);

  JsonMap toJson() => _$UserToJson(this);

  final int id;
  final String username;
  @JsonKey(name: 'created_at')
  final DateTime createdTime;
  @Uint8ListConverter()
  final Uint8List picture;

  @override
  List<Object> get props => [id, username, createdTime, picture];
}
