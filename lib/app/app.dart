import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/authenticate/views/views.dart';
import 'package:vhome_repository/vhome_repository.dart';

class App extends StatelessWidget {
  App({required this.repository, super.key});

  final VhomeRepository repository;

  @override
    Widget build(BuildContext context) {
      return RepositoryProvider.value(
        value: repository,
        child: const AppView()
      );
    }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'vHome',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)
        ),
        home: const MainContainer(),
      );
    }
}

class MainContainer extends StatelessWidget {
  const MainContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surfaceContainer,
        title: const Text("vHome"),
      ),
      body: AuthGuard(),
    );
  }
}
