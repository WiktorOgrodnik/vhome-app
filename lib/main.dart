import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vhome_frontend/auth.dart';
import 'package:vhome_frontend/views/login.dart';

void main() {
  runApp(const MyApp());
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

Future<List<VList>> fetchVlists() async {

  var sessionSid = await SessionManager().get('session.sid');

  print(sessionSid);

  final response = await http
    .get(Uri.parse('http://localhost:8080/lists'), headers: {'cookie': sessionSid });
  
  List<VList> tempList = [];

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    for (var v in data) {
      tempList.add(VList.fromJson(v));
    }
    return tempList;
  } else {
    throw Exception('Failed to load message.');
  }
}

class VList {
  final int id;
  final int groupId;
  final String title;

  const VList({
    required this.id,
    required this.groupId,
    required this.title,
  });

  factory VList.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'group_id': int groupId,
        'name': String title,
      } => 
        VList (
          id: id,
          groupId: groupId,
          title: title,
        ),
      _ => throw const FormatException('Failed to load list'),
    };
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'vHome',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MainContainer(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = "";
}

class MainContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: AuthGuard(),
    );
  }
}

class AuthGuard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Auth().authState$,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == AuthState.pending) {
          return Center(child: CircularProgressIndicator());
        }
        switch (snapshot.data) {
          case AuthState.unauthenticated:
            return LoginScreen();
          case AuthState.authenticated:
            return HomePage();
          default:
            return CircularProgressIndicator();
        }
      }
    ); 
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

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = ApiPage();
      case 1:
        page = Placeholder();
      case 2:
        page = LogOutPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text("Home"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.devices),
                    label: Text("Devices"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.exit_to_app),
                    label: Text("Logout"),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                }
              ),
            ),
            page,
          ],
        );
      }
    );
  }
}

class ApiPage extends StatefulWidget {
  @override
    State<StatefulWidget> createState() => ApiPageState();
}

class ApiPageState extends State<ApiPage> {
  
  late Future<List<VList>> futureLists;

  @override
  void initState() {
    super.initState();
    futureLists = fetchVlists();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VList>>(
      future: futureLists,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              for (var vlist in snapshot.data!)
                Column(
                  children: [
                    SizedBox(width: 10),
                    Text(vlist.title),
                  ],
                )
            ],
          );
        } else {
          return Placeholder();
        }
      } 
    );
  }
}

class LogOutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              Auth().logout();
            },
            child: Text("Logout"),
          ),
        ],
      )
    );
  }
}
