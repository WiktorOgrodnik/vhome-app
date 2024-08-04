import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vhome_web_api/src/models/models.dart';

part 'user_login.g.dart';

@JsonSerializable()
class UserLogin extends Equatable {
  const UserLogin({
    required this.id,
    required this.username,
    required this.token,
    this.group,
  });
  
  factory UserLogin.fromJson(JsonMap json) 
    => _$UserLoginFromJson(json);

  JsonMap toJson() => _$UserLoginToJson(this);

  final int id;
  final String username;
  final String token;
  final String? group;

  @override
  List<Object?> get props => [id, username, token, group];
}
