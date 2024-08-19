import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:screen_state/screen_state.dart';
import 'package:vhome_web_api/vhome_web_api.dart';
import 'package:http/http.dart' as http;

class DeviceApi {
  DeviceApi();
  final _screen = Screen();

  final _devicesPeriodicUpdate$ = RepeatStream<void>((_) => TimerStream<void>(null, const Duration(minutes: 1))).asBroadcastStream();
  final _devicesOutdated$ = BehaviorSubject<void>.seeded(null);
  Stream<ScreenStateEvent> get _screenUnlockStream$ =>
    _screen.screenStateStream.where((elt) => elt == ScreenStateEvent.SCREEN_UNLOCKED);

  Stream<List<Device>> getDevices(String token) =>
    Rx.merge([
      _devicesPeriodicUpdate$,
      _devicesOutdated$,
      if (Platform.isAndroid)
      _screenUnlockStream$,
    ]).switchMap((_) =>
      Stream.fromFuture(fetchDevices(token))
    ).map((list) {
      list.sort((a, b) => -a.lastUpdated.compareTo(b.lastUpdated));

      return list;
    }).asBroadcastStream();

  Stream<Device> getDevice(String token, int deviceId) =>
    Rx.merge([
      _devicesPeriodicUpdate$,
      _devicesOutdated$,
      if (Platform.isAndroid)
      _screenUnlockStream$, 
    ]).switchMap((_) =>
      Stream.fromFuture(_fetchDevice(token, deviceId))
    ).asBroadcastStream();

  Future<List<Device>> fetchDevices(String token) async {
    final uri = Uri.parse("$apiUrl/devices");
    final response = await http.get(uri, headers: { 'Authorization': token } );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Can not get the Devices');
    }

    final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Device> devices = [];

    for (var rawDevice in data) {
      final deviceType = rawDevice['dev_t'];
      final deviceId = rawDevice['id'];
      final uriDetails = Uri.parse("$apiUrl/$deviceType/$deviceId");
      final responseDetails = await http.get(uriDetails, headers: { 'Authorization': token });

      if (responseDetails.statusCode != HttpStatus.ok) {
        throw Exception("Can not get the $deviceType");
      }

      final dynamic dataDetails = jsonDecode(utf8.decode(responseDetails.bodyBytes));
      final JsonMap dataCombined = {};
      dataCombined.addAll(rawDevice);
      dataCombined.addAll(dataDetails);
      
      final device = Device.fromJson(dataCombined);
      devices.add(device);
    }

    return devices; 
  }

  Future<Device> _fetchDevice(String token, int deviceId) async {
    final uri = Uri.parse("$apiUrl/device/$deviceId");
    final response = await http.get(uri, headers: { 'Authorization': token } );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception("Can not get the device $deviceId");
    }

    final JsonMap data = jsonDecode(utf8.decode(response.bodyBytes));
    final deviceType = data['dev_t'];
    final uriDetails = Uri.parse("$apiUrl/$deviceType/$deviceId");
    final responseDetails = await http.get(uriDetails, headers: { 'Authorization': token });

    if (responseDetails.statusCode != HttpStatus.ok) {
      throw Exception("Can not get the $deviceType");
    }

    final dynamic dataDetails = jsonDecode(utf8.decode(responseDetails.bodyBytes));
    final JsonMap dataCombined = {};
    dataCombined.addAll(data);
    dataCombined.addAll(dataDetails);
    
    return Device.fromJson(dataCombined);
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

  void refreshDevices() {
    _devicesOutdated$.add(null);
  }
}
