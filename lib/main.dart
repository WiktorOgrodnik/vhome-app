import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:vhome_frontend/app/app.dart';
import 'package:vhome_repository/vhome_repository.dart';
import 'package:vhome_web_api/vhome_web_api.dart';


void main() {
  DeviceApi deviceApi = DeviceApi();
  TasksetApi tasksetApi = TasksetApi();
  TaskApi taskApi = TaskApi();

  VhomeRepository vhomeRepository = VhomeRepository(
    deviceApi: deviceApi,
    tasksetApi: tasksetApi,
    taskApi: taskApi
  );

  runApp(App(repository: vhomeRepository));
}

Future<Message> fetchMessage() async {
  final response = await http
    .get(Uri.parse('http://localhost:8080/'));

  if (response.statusCode == 200) {
    return Message.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load message.');
  }
}

class Message {
  final String message;

  const Message({
    required this.message
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'content': String message,
      } => 
        Message(
          message: message,
        ),
      _ => throw const FormatException('Failed to load message'),
    };
  }
}


class BigCart extends StatelessWidget {
  const BigCart({
    super.key,
    required this.pair,
  });

  final String pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair,
          style: style,
        ),
      ),
    );
  }
}
