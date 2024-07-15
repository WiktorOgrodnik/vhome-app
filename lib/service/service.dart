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
    var token = await SessionManager().get('user.token');
    var response = await http.get(uri, headers: {'Authorization': token} );
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode != HttpStatus.ok) {
      throw data["content"];    
    }

    return data;
  }

  static Future<List<dynamic>> getDataList(String target, {int? limit}) async {
    var res = await getData(target) as List<dynamic>;
    
    if (limit != null) {
      res = res.take(limit).toList();
    }

    return res;
  }
}

