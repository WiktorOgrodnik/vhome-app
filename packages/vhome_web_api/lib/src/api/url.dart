import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

const String apiUrlRelease = "https://majanska-piramida.hopto.org";

const String apiUrlLinux = "http://localhost:8080";
const String apiUrlAndorid = "http://10.0.2.2:8080";

String get apiUrl => kReleaseMode ? apiUrlRelease : (Platform.isAndroid ? apiUrlAndorid : apiUrlLinux);  
