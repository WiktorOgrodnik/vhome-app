import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:vhome_frontend/consts/api_url.dart';

class Service {
  final client = http.Client();

  static Future<dynamic> getData(String target) async {
    var uri = Uri.parse("$apiUrl/$target");
    var sid = await SessionManager().get('session.sid');
    var response = await http.get(uri, headers: {'cookie': sid} );
    var data = jsonDecode(response.body);

    if (response.statusCode != HttpStatus.ok) {
      throw data["content"];    
    }

    return data;
  }

  static Future<List<dynamic>> getDataList(String target) async {
    var res = await getData(target);
    return res as List<dynamic>;
  }
}

