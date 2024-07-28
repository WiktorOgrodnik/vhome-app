import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/authentication/bloc/authentication_bloc.dart';
import 'package:vhome_frontend/group_selection_page/views/views.dart';
import 'package:vhome_frontend/home/view/home_page.dart';
import 'package:vhome_frontend/login_page/view/view.dart';
import 'package:vhome_frontend/splash/splash.dart';
import 'package:vhome_repository/vhome_repository.dart';

class App extends StatelessWidget {
  App({required this.repository, super.key});

  final VhomeRepository repository;

  @override
    Widget build(BuildContext context) {
      return RepositoryProvider.value(
        value: repository,
        child: BlocProvider(
          create: (_) => AuthenticationBloc(repository: repository),
          child: const AppView(),
        ),
      );
    }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      title: 'vHome',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)
      ),
      onGenerateRoute: (_) => SplashPage.route(),
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthState.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
              case AuthState.groupUnselected:
                _navigator.pushAndRemoveUntil<void>(
                  GroupSelectionPage.route(),
                  (route) => false,
                );
              case AuthState.groupSelected:
                _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                  (route) => false,
                );
              default:
                _navigator.pushAndRemoveUntil<void>(
                  SplashPage.route(),
                  (route) => false,
                );
            }
          },
          child: child,
        );
      },
    );
  }
}
