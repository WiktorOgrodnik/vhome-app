import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vhome_web_api/src/models/models.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  const User({
    required this.id,
    required this.username,
    required this.token,
    this.isGroupSelected = false,
  });
  
  factory User.fromJson(JsonMap json, {bool isGroupSelected = false}) => _$UserFromJson(json, isGroupSelected);

  JsonMap toJson() => _$UserToJson(this);

  final int id;
  final String username;
  final String token;
  final bool isGroupSelected;

  @override
  List<Object> get props => [id, username, token];
}
