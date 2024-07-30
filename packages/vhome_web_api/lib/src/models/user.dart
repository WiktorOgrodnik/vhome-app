import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vhome_web_api/src/models/models.dart';

part 'user.g.dart';

class Uint8ListConverter implements JsonConverter<Uint8List, dynamic> {
  const Uint8ListConverter();
  
  @override
  Uint8List fromJson(dynamic json) {
    return json as Uint8List;
  }

  @override
  dynamic toJson(Uint8List object) {
    return object;
  }
}

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
  final DateTime createdTime;
  @Uint8ListConverter()
  final Uint8List picture;

  @override
  List<Object> get props => [id, username, createdTime, picture];
}
