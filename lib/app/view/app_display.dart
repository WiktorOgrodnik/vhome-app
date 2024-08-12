import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/authentication/bloc/authentication_bloc.dart';
import 'package:vhome_frontend/home/view/home_page_display.dart';
import 'package:vhome_frontend/qrcode_page/view/view.dart';
import 'package:vhome_frontend/splash/splash.dart';
import 'package:vhome_repository/vhome_repository.dart';

class AppDisplay extends StatelessWidget {
  AppDisplay({required this.repository, super.key});

  final VhomeRepository repository;

  @override
    Widget build(BuildContext context) {
      return RepositoryProvider.value(
        value: repository,
        child: BlocProvider(
          create: (_) => AuthenticationBloc(repository: repository),
          child: const AppDisplayView(),
        ),
      );
    }
}

class AppDisplayView extends StatefulWidget {
  const AppDisplayView({super.key});

  @override
  State<AppDisplayView> createState() => _AppDisplayViewState();
}

class _AppDisplayViewState extends State<AppDisplayView> {
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
        return BlocListener<AuthenticationBloc, AuthState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  QrcodePage.route(),
                  (route) => false,
                );
              case AuthStatus.groupSelected:
                _navigator.pushAndRemoveUntil<void>(
                  HomeDisplayPage.route(),
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
