import 'dart:async';
import 'package:vhome_frontend/models/group.dart';
import 'package:vhome_frontend/service/service.dart';

class GroupService {
  static final GroupService _instance = GroupService._internal();
  factory GroupService() => _instance;
  GroupService._internal();

  Future<List<Group>> getGroups() async {
    var data = await Service.getDataList("groups");
    return data.map((x) => Group.fromJson(x)).toList();
  }
}
