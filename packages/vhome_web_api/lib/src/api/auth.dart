import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

class AuthApi {
  AuthApi();

  Future<JsonMap> _combineWithPicture(Response response) async {
    final data = jsonDecode(response.body);
    final token = data['token'];
    final userId = data['id'];
    final Uint8List pictureData = await getUserPicture(token, userId);
    final JsonMap dataCombined = {};
    dataCombined.addAll(data);
    dataCombined.addAll({
      "picture": pictureData
    });

    return dataCombined;
  }

  Future<AuthModel?> getAuthToken(String username, String password) async {
    var response = await post(
      Uri.parse("$apiUrl/login"),
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
      headers: {
        "Accept": "application/json",
        "content-type":"application/json"
      },
    );


    return response.statusCode == 200
        ? AuthModel.fromJson(await _combineWithPicture(response))
        : null;
  }
  
  Future<AuthModel?> selectGroup(String token, int groupId) async {
    var uri = Uri.parse("$apiUrl/group/select/$groupId");
    var response = await get(uri, headers: { 'Authorization': token });

    return response.statusCode == 200
        ? AuthModel.fromJson(await _combineWithPicture(response), isGroupSelected: true)
        : null;
  }

  Future<AuthModel?> unselectGroup(String token) async {
    var uri = Uri.parse("$apiUrl/group/unselect");
    var response = await get(uri, headers: { 'Authorization': token });

    return response.statusCode == 200 ?
      AuthModel.fromJson(await _combineWithPicture(response)) :
      null;
  }

  Future<AuthModel?> logout(String token) async {
    var uri = Uri.parse("$apiUrl/logout");
    await get(uri, headers: { 'Authorization': token });

    return null;
  }

  Future<Uint8List> getUserPicture(String token, int id) async {
    final uri = Uri.parse("$apiUrl/user/$id/picture");
    final response = await get(uri, headers: { 'Authorization': token });
    
    if (response.statusCode != 200) {
      throw Exception("Can not get user picture");
    }

    return response.bodyBytes;
  }
}
