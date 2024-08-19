import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io' show Platform;

final String apiUrlRelease = dotenv.env['APIURL'] ?? "https://no-url.com";

const String apiUrlLinux = "http://localhost:8080";
const String apiUrlAndorid = "http://10.0.2.2:8080";

String get apiUrl => kReleaseMode ? apiUrlRelease : (Platform.isAndroid ? apiUrlAndorid : apiUrlLinux);  
