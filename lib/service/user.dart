import 'dart:async';
import 'dart:convert';

import 'package:vhome_frontend/consts/api_url.dart';
import 'package:vhome_frontend/models/user.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

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

  Future<User?> selectGroup(int groupId) async {
    var uri = Uri.parse("$apiUrl/group/select/$groupId");
    var token = await SessionManager().get('user.token');

    var response = await get(uri, headers: { 'Authorization': token });

    return response.statusCode == 200 ?
      User.fromJson(jsonDecode(response.body)) :
      null;
  }

  Future<int> logout(int taskId) async {
    var uri = Uri.parse("$apiUrl/logout");
    var token = await SessionManager().get('user.token');

    return 200;
  }
}
