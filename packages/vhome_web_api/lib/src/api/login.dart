import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

class AuthApi {
  AuthApi();

  Future<UserLogin?> getAuthToken(String username, String password) async {
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
        ? UserLogin.fromJson(jsonDecode(response.body))
        : null;
  }
  
  Future<UserLogin?> selectGroup(String token, int groupId) async {
    var uri = Uri.parse("$apiUrl/group/select/$groupId");
    var response = await get(uri, headers: { 'Authorization': token });

    return response.statusCode == 200
        ? UserLogin.fromJson(jsonDecode(response.body))
        : null;
  }

  Future<UserLogin?> unselectGroup(String token) async {
    var uri = Uri.parse("$apiUrl/group/unselect");
    var response = await get(uri, headers: { 'Authorization': token });

    return response.statusCode == 200 ?
      UserLogin.fromJson(jsonDecode(response.body)) :
      null;
  }

  Future<UserLogin?> logout(String token) async {
    var uri = Uri.parse("$apiUrl/logout");
    await get(uri, headers: { 'Authorization': token });

    return null;
  }
}
