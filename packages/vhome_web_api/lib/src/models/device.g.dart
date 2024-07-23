// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Thermometer _$ThermometerFromJson(Map<String, dynamic> json) => Thermometer(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      deviceType: $enumDecodeNullable(_$DeviceTypeEnumMap, json['dev_t']) ??
          DeviceType.thermometer,
      lastTemperature: (json['last_temp'] as num?)?.toDouble(),
      lastUpdated: json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$ThermometerToJson(Thermometer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dev_t': _$DeviceTypeEnumMap[instance.deviceType]!,
      'last_temp': instance.lastTemperature,
      'last_updated': instance.lastUpdated?.toIso8601String(),
    };

const _$DeviceTypeEnumMap = {
  DeviceType.thermometer: 'thermometer',
  DeviceType.other: 'other',
};
