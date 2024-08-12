import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

    return response.statusCode == 200
      ? UserLogin.fromJson(jsonDecode(response.body))
      : null;
  }

  Future<UserLogin?> logout(String token) async {
    var uri = Uri.parse("$apiUrl/logout");
    await get(uri, headers: { 'Authorization': token });

    return null;
  }

  Future<UserLogin?> addGroup(String token, String name) async {
    final uri = Uri.parse("$apiUrl/groups");
    final response = await post(
      uri, 
      headers: { 
        'Authorization': token,
        'Accept': 'application/json',
        'content-type': 'application/json',
      },
      body: jsonEncode({ 'name': name }),
    );

    return response.statusCode == 200
      ? UserLogin.fromJson(jsonDecode(response.body))
      : null;
  }

  Future<UserLogin?> acceptInvitation(String token, String invitation) async {
    final uri = Uri.parse("$apiUrl/group/accept");
    final response = await post(
      uri, 
      headers: { 'Authorization': token },
      body: invitation,
    );

    return response.statusCode == 200
      ? UserLogin.fromJson(jsonDecode(response.body))
      : null;
  }

  Future<UserLogin?> leaveGroup(String token) async {
    final uri = Uri.parse("$apiUrl/group/leave");
    final response = await post(uri, headers: { 'Authorization': token } );

    return response.statusCode == 200
      ? UserLogin.fromJson(jsonDecode(response.body))
      : null;
  }

  Future<String> getPairingCode() async {
    final uri = Uri.parse("$apiUrl/display/pairing_code");
    final response = await get(uri);

    if (response.statusCode != HttpStatus.ok) {
      throw Exception("Can not get pairing code");
    }
    
    return response.body;
  }

  Future<UserLogin?> getDisplayToken(String pairingCode) async {
    final uri = Uri.parse("$apiUrl/display/pairing_code");
    final response = await post(uri, body: pairingCode);

    return response.statusCode == HttpStatus.ok
      ? UserLogin.fromJson(jsonDecode(response.body))
      : null;
  }

  Future<void> addDisplay(String token, String pairingCode) async {
    final uri = Uri.parse("$apiUrl/display");
    final response = await post(uri, headers: { 'Authorization': token }, body: pairingCode);
    
    print(response.statusCode);

    if (response.statusCode != HttpStatus.ok) {
      throw Exception("Can not add display");
    }
  }
}
