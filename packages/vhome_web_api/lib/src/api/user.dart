import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:rxdart/rxdart.dart';
import 'package:vhome_web_api/vhome_web_api.dart';
import 'package:http/http.dart' as http;

class UserApi {
  UserApi();

  final _usersOutdated = BehaviorSubject<void>.seeded(null);

  Stream<void> userOutdated() => _usersOutdated.asBroadcastStream();
  Stream<List<User>> getUsers(String token) => 
    _usersOutdated.switchMap((_) => Stream.fromFuture(_fetchUsers(token))).asBroadcastStream();

  Future<Uint8List> _getUserPicture(String token, int id) async {
    final uri = Uri.parse("$apiUrl/user/$id/picture");
    final response = await http.get(uri, headers: { 'Authorization': token });
    
    if (response.statusCode != 200) {
      throw Exception("Can not get user picture");
    }

    return response.bodyBytes;
  }

  Future<JsonMap> _combineWithPicture(String token, JsonMap data) async {
    final id = data['id'];
    final Uint8List pictureData = await _getUserPicture(token, id);
    final JsonMap dataCombined = {};
    dataCombined.addAll(data);
    dataCombined.addAll({
      "picture": pictureData
    });

    return dataCombined;
  }

  Future<List<User>> _fetchUsers(String token) async {
    final uri = Uri.parse("$apiUrl/users");
    final response = await http.get(uri, headers: { 'Authorization': token } );
    
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Can not get the Users');
    }

    final List<dynamic> responseData = jsonDecode(response.body);
    
    return Future.wait(responseData.map((userMap) async 
        => User.fromJson(await _combineWithPicture(token, userMap))));
  }

  void refreshUsers() {
    _usersOutdated.add(null);
  }
}
