import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vhome_frontend/app/app.dart';
import 'package:vhome_repository/vhome_repository.dart';
import 'package:vhome_web_api/vhome_web_api.dart';


Future main() async {
  await dotenv.load();

  final deviceApi = DeviceApi();
  final measurementApi = MeasurementApi();
  final groupApi = GroupApi();
  final tasksetApi = TasksetApi();
  final taskApi = TaskApi();
  final authApi = AuthApi();
  final userApi = UserApi();

  VhomeRepository vhomeRepository = VhomeRepository(
    deviceApi: deviceApi,
    measurementApi: measurementApi,
    groupApi: groupApi,
    tasksetApi: tasksetApi,
    taskApi: taskApi,
    authApi: authApi,
    userApi: userApi,
  );

  runApp(App(repository: vhomeRepository));
}
