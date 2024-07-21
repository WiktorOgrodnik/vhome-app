import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vhome_web_api/src/models/json_map.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

part 'taskset.g.dart';

@JsonSerializable()
class Taskset extends Equatable {
  const Taskset({
    required this.id,
    required this.title,
  });

  factory Taskset.fromJson(JsonMap json) =>
    _$TasksetFromJson(json);
  
  JsonMap toJson() => _$TasksetToJson(this);

  final int id;
  @JsonKey(name: 'name')
  final String title;

  Taskset copyWith({
    int? id,
    String? title,
  }) {
    return Taskset(
      id: id ?? this.id,
      title: title ?? this.title
    );
  }

  @override
  List<Object> get props => [id, title];
}
