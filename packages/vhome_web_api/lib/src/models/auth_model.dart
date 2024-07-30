import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vhome_web_api/src/models/models.dart';

part 'auth_model.g.dart';

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
class AuthModel extends Equatable {
  const AuthModel({
    required this.id,
    required this.username,
    required this.token,
    required this.picture,
    this.isGroupSelected = false,
  });
  
  factory AuthModel.fromJson(JsonMap json, {bool isGroupSelected = false}) 
    => _$AuthModelFromJson(json, isGroupSelected);

  JsonMap toJson() => _$AuthModelToJson(this);

  final int id;
  final String username;
  final String token;
  final bool isGroupSelected;
  @Uint8ListConverter()
  final Uint8List picture;

  @override
  List<Object> get props => [id, username, token, isGroupSelected, picture];
}
