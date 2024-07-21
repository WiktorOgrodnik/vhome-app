import 'dart:async';
import 'dart:convert';
import 'package:vhome_frontend/consts/api_url.dart';
import 'package:vhome_frontend/models/group.dart';

import 'package:http/http.dart' as http;
import 'package:vhome_repository/vhome_repository.dart';

class GroupService {
  static final GroupService _instance = GroupService._internal();
  factory GroupService() => _instance;
  GroupService._internal();

  Future<List<Group>> getGroups(VhomeRepository repository) async {
    final uri = Uri.parse("$apiUrl/groups");
    final token = repository.getToken;
    final response = await http.get(uri, headers: { 'Authorization': token! } );
    final List<dynamic> responseData = jsonDecode(response.body);
    final List<Group> fetchedGroups = responseData.map((group) => Group.fromJson(group)).toList();

    return fetchedGroups;
  }
}
