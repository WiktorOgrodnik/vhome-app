import 'package:flutter/material.dart';
import 'package:vhome_frontend/app/app.dart';
import 'package:vhome_repository/vhome_repository.dart';
import 'package:vhome_web_api/vhome_web_api.dart';


void main() {
  final deviceApi = DeviceApi();
  final groupApi = GroupApi();
  final tasksetApi = TasksetApi();
  final taskApi = TaskApi();
  final authApi = AuthApi();
  final userApi = UserApi();

  VhomeRepository vhomeRepository = VhomeRepository(
    deviceApi: deviceApi,
    groupApi: groupApi,
    tasksetApi: tasksetApi,
    taskApi: taskApi,
    authApi: authApi,
    userApi: userApi,
    display: true,
  );

  runApp(AppDisplay(repository: vhomeRepository));
}
