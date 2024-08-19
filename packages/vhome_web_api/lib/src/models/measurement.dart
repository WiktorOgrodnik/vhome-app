import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vhome_web_api/src/models/json_map.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

part 'measurement.g.dart';

enum MeasurementTimeRange {
  hour,
  day,
  week,
  month,
}

@JsonSerializable()
class Measurement extends Equatable {
  const Measurement({
    required this.label,
    required this.value,
    required this.time,
  });

  factory Measurement.fromJson(JsonMap json) =>
    _$MeasurementFromJson(json);
  
  JsonMap toJson() => _$MeasurementToJson(this);

  final String label;
  final double value;
  final DateTime time;

  Measurement copyWith({
    String? label,
    double? value,
    DateTime? time,
  }) {
    return Measurement(
      label: label ?? this.label,
      value: value ?? this.value,
      time: time ?? this.time,
    );
  }

  @override
  List<Object> get props => [label, value, time];
}
