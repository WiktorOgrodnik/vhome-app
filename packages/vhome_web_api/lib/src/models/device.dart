import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vhome_web_api/src/models/models.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

part 'device.g.dart';

enum DeviceType {
  thermometer,
  other,
}

enum ThermometerFields {
  none,
  onlyThermometer,
  onlyHumidity,
  thermometerHumidity,
}

sealed class Device extends Equatable {
  const Device({
    this.id = 0,
    required this.name,
    required this.deviceType,
  });
  
  factory Device.fromJson(JsonMap json) {
    switch ($enumDecodeNullable(_$DeviceTypeEnumMap, json['dev_t'])) {
      case DeviceType.thermometer:
        return Thermometer.fromJson(json);
      default:
        throw "Unimplemented type of Device: ${json['dev_t']}";
    }
  }
  
  JsonMap toJson();

  final int id;
  final String name;
  @JsonKey(name: 'dev_t')
  final DeviceType deviceType;

  Device copyWith({
    int? id,
    String? name,
    DeviceType? deviceType
  });

  Map<String, String> get infoFields;

  @override
  List<Object?> get props => [id, name, deviceType];
}

@JsonSerializable()
class DeviceToken extends Equatable {
  const DeviceToken({
    required this.token,
  });

  factory DeviceToken.fromJson(JsonMap json) =>
    _$DeviceTokenFromJson(json);
  
  JsonMap toJson() => _$DeviceTokenToJson(this);

  final String token;

  DeviceToken copyWith({
    String? token,
  }) {
    return DeviceToken(
      token: token ?? this.token
    );
  }
  
  @override
  List<Object?> get props => [token];

}

@JsonSerializable()
final class Thermometer extends Device {
  const Thermometer({
    required super.id,
    required super.name,
    super.deviceType = DeviceType.thermometer,
    required this.lastTemperature,
    required this.lastUpdated,
    required this.lastHumidity,
  });

  factory Thermometer.fromJson(JsonMap json) =>
    _$ThermometerFromJson(json);
  
  @override
  JsonMap toJson() => _$ThermometerToJson(this);
  
  @JsonKey(name: 'last_temp')
  final double? lastTemperature;
  @JsonKey(name: 'last_humidity')
  final double? lastHumidity;
  @JsonKey(name: 'last_updated')
  final DateTime lastUpdated;

  @override
  Device copyWith({
    int? id,
    String? name,
    DeviceType? deviceType,
    double? lastTemperature,
    double? lastHumidity,
    DateTime? lastUpdated,
  }) {
    return Thermometer(
      id: id ?? this.id,
      name: name ?? this.name,
      deviceType: deviceType ?? this.deviceType,
      lastTemperature: lastTemperature ?? this.lastTemperature,
      lastHumidity: lastHumidity ?? this.lastHumidity,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, String> get infoFields => {
    "Last temperature": lastTemperature != null ? lastTemperature.toString() : "null",
    "Last humidity": lastHumidity != null ? lastHumidity.toString() : "null",
    "Last updated": lastUpdated.toString()
  };

  ThermometerFields get fields {
    switch ((lastTemperature, lastHumidity)) {
      case (null, null):
        return ThermometerFields.none;
      case (_, null):
        return ThermometerFields.onlyThermometer;
      case (null, _):
        return ThermometerFields.onlyHumidity;
      default:
        return ThermometerFields.thermometerHumidity;
    }
  }

    @override
  List<Object?> get props => [
    super.id,
    super.name,
    super.deviceType,
    lastTemperature,
    lastHumidity,
    lastUpdated,
  ]; 
}
