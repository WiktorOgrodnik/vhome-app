import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:vhome_web_api/vhome_web_api.dart';
import 'package:http/http.dart' as http;

class MeasurementApi {
  MeasurementApi();

  Future<List<Measurement>> getMeasurements(String token, int deviceId, MeasurementTimeRange timeRange) async {
    final uri = Uri.parse("$apiUrl/measurements/$deviceId/${timeRange.name}");
    final response = await http.get(uri, headers: { 'Authorization': token });
    
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Can not get the Measurements');
    }

    final List<dynamic> responseData = jsonDecode(response.body);
    final List<Measurement> fetchedMeasurements = responseData.map((measurement) => Measurement.fromJson(measurement)).toList();

    return fetchedMeasurements; 
  }
}
