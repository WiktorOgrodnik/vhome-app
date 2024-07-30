import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/devices_page/view/view.dart';
import 'package:vhome_frontend/home/cubit/home_cubit.dart';
import 'package:vhome_frontend/home/view/view.dart';
import 'package:vhome_frontend/settings/views/views.dart';
import 'package:vhome_frontend/tasksets_page/view/view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedPage = context.select((HomeCubit cubit) => cubit.state.page);

    final Widget page;
    switch (selectedPage) {
      case HomeSubPage.tasksets:
        page = TasksetsPage();
      case HomeSubPage.devices:
        page = DevicesPage();
      case HomeSubPage.settings:
        page = SettingsPage();
      default:
        throw UnimplementedError('no widget for $selectedPage');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Vhome"),
        backgroundColor: theme.colorScheme.surfaceContainer,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 500) {
            return HomePageMobile(
              index: selectedPage.index,
              child: page,
            );
          } else {
            return HomePageDesktop(
              index: selectedPage.index,
              child: page,
            );
          }
        }
      )
    );
  }
}

