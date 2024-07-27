import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vhome_web_api/src/models/models.dart';

part 'group.g.dart';

@JsonSerializable()
class Group extends Equatable {
  const Group({
    required this.id,
    required this.name,
  });

  factory Group.fromJson(JsonMap json) => _$GroupFromJson(json);

  JsonMap toJson() => _$GroupToJson(this);

  final int id;
  final String name;
  
  @override
  List<Object> get props => [id, name];
}
