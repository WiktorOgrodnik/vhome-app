import 'dart:io' show Platform;

const String apiUrlLinux = "http://localhost:8080";
const String apiUrlAndorid = "http://10.0.2.2:8080";

String get apiUrl => Platform.isAndroid ? apiUrlAndorid : apiUrlLinux;  
