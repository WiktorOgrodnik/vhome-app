import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:vhome_web_api/vhome_web_api.dart';
import 'package:http/http.dart' as http;

class DeviceApi {
  DeviceApi();

  final _devicesOutdated = BehaviorSubject<void>.seeded(null);

  Stream<void> get devicesOutdated$ => _devicesOutdated.asBroadcastStream();
  Stream<List<Device>> getDevices(String token) => 
    _devicesOutdated.switchMap((_) => Stream.fromFuture(fetchDevices(token))).asBroadcastStream();

  Future<List<Device>> fetchDevices(String token) async {
    final uri = Uri.parse("$apiUrl/devices");
    final response = await http.get(uri, headers: { 'Authorization': token } );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Can not get the Devices');
    }

    final List<dynamic> data = jsonDecode(response.body);
    List<Device> devices = [];

    for (var rawDevice in data) {
      final deviceType = rawDevice['dev_t'];
      final deviceId = rawDevice['id'];
      final uriDetails = Uri.parse("$apiUrl/$deviceType/$deviceId");
      final responseDetails = await http.get(uriDetails, headers: { 'Authorization': token });

      if (responseDetails.statusCode != HttpStatus.ok) {
        throw Exception("Can not get the $deviceType");
      }

      final dynamic dataDetails = jsonDecode(responseDetails.body);
      final JsonMap dataCombined = {};
      dataCombined.addAll(rawDevice);
      dataCombined.addAll(dataDetails);
      
      final device = Device.fromJson(dataCombined);
      devices.add(device);
    }

    return devices; 
  }

  Future<DeviceToken> addDevice(String token, String name, DeviceType deviceType) async {
    final uri = Uri.parse("$apiUrl/devices");
    final payload = jsonEncode({ "name": name, "dev_t": deviceType.name });

    final response = await http.post(
      uri,
      headers: {
        'Authorization': token,
        'Accept': 'application/json',
        'content-type': 'application/json',
      },
      body: payload
    );

    if (response.statusCode != HttpStatus.created) {
      throw Exception("Can not create device");
    }
    
    final data = DeviceToken.fromJson(jsonDecode(response.body));
    return data; 
  }
}
