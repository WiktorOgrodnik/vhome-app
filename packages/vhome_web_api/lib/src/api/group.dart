import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

class GroupApi {
  GroupApi();
  
  final _groupsOutdated = BehaviorSubject<void>.seeded(null);

  Stream<List<Group>> getGroups(String token) =>
    _groupsOutdated.switchMap((_) => Stream.fromFuture(_fetchGroups(token)));

  Future<List<Group>> _fetchGroups(String token) async {
    final uri = Uri.parse("$apiUrl/groups");
    final response = await http.get(uri, headers: { 'Authorization': token } );
    
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Can not get the Groups');
    }

    final List<dynamic> responseData = jsonDecode(response.body);
    final List<Group> fetchedGroups = responseData.map((group) => Group.fromJson(group)).toList();

    return fetchedGroups;
  }
}
