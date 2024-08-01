import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';

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
