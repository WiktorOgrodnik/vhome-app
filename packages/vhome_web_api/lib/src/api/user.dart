import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

class UserApi {
  UserApi();

  Future<User?> getAuthToken(String username, String password) async {
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

    return response.statusCode == 200 ? 
      User.fromJson(jsonDecode(response.body)) : 
      null;
  }
  
  Future<User?> selectGroup(String token, int groupId) async {
    var uri = Uri.parse("$apiUrl/group/select/$groupId");
    var response = await get(uri, headers: { 'Authorization': token });

    return response.statusCode == 200 ?
      User.fromJson(jsonDecode(response.body), isGroupSelected: true) :
      null;
  }

  Future<User?> unselectGroup(String token) async {
    var uri = Uri.parse("$apiUrl/group/unselect");
    var response = await get(uri, headers: { 'Authorization': token });

    return response.statusCode == 200 ?
      User.fromJson(jsonDecode(response.body)) :
      null;
  }

  Future<User?> logout(String token) async {
    var uri = Uri.parse("$apiUrl/logout");
    await get(uri, headers: { 'Authorization': token });

    return null;
  }
}
