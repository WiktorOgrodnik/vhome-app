import 'dart:async';
import 'dart:convert';

import 'package:vhome_frontend/consts/api_url.dart';
import 'package:vhome_frontend/models/user.dart';
import 'package:http/http.dart';
import 'package:vhome_repository/vhome_repository.dart';

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
  
  Future<User?> selectGroup(VhomeRepository repository, int groupId) async {
    var uri = Uri.parse("$apiUrl/group/select/$groupId");
    var token = repository.getToken;

    var response = await get(uri, headers: { 'Authorization': token! });

    return response.statusCode == 200 ?
      User.fromJson(jsonDecode(response.body)) :
      null;
  }

  Future<User?> unselectGroup(VhomeRepository repository) async {
    var uri = Uri.parse("$apiUrl/group/unselect");
    var token = repository.getToken;

    var response = await get(uri, headers: { 'Authorization': token! });

    return response.statusCode == 200 ?
      User.fromJson(jsonDecode(response.body)) :
      null;
  }

  Future<void> logout(VhomeRepository repository) async {
    var uri = Uri.parse("$apiUrl/logout");
    var token = repository.getToken;

    await get(uri, headers: { 'Authorization': token! });
  }
}
