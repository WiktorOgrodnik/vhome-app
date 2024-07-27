import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vhome_web_api/vhome_web_api.dart';

class GroupApi {
  GroupApi();

  Future<List<Group>> getGroups(String token) async {
    final uri = Uri.parse("$apiUrl/groups");
    final response = await http.get(uri, headers: { 'Authorization': token } );
    final List<dynamic> responseData = jsonDecode(response.body);
    final List<Group> fetchedGroups = responseData.map((group) => Group.fromJson(group)).toList();

    return fetchedGroups;
  }
}
