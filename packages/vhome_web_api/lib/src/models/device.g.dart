// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceToken _$DeviceTokenFromJson(Map<String, dynamic> json) => DeviceToken(
      token: json['token'] as String,
    );

Map<String, dynamic> _$DeviceTokenToJson(DeviceToken instance) =>
    <String, dynamic>{
      'token': instance.token,
    };

Thermometer _$ThermometerFromJson(Map<String, dynamic> json) => Thermometer(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String,
      deviceType: $enumDecodeNullable(_$DeviceTypeEnumMap, json['dev_t']) ??
          DeviceType.thermometer,
      lastTemperature: (json['last_temp'] as num?)?.toDouble(),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
      lastHumidity: (json['last_humidity'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ThermometerToJson(Thermometer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dev_t': _$DeviceTypeEnumMap[instance.deviceType]!,
      'last_temp': instance.lastTemperature,
      'last_humidity': instance.lastHumidity,
      'last_updated': instance.lastUpdated.toIso8601String(),
    };

const _$DeviceTypeEnumMap = {
  DeviceType.thermometer: 'thermometer',
  DeviceType.other: 'other',
};
