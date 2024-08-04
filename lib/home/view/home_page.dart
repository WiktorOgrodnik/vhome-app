import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/devices_page/view/view.dart';
import 'package:vhome_frontend/home/cubit/home_cubit.dart';
import 'package:vhome_frontend/home/view/view.dart';
import 'package:vhome_frontend/settings/views/views.dart';
import 'package:vhome_frontend/tasksets_page/view/view.dart';
import 'package:vhome_frontend/users/users.dart';
import 'package:vhome_repository/vhome_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => 
          UsersBloc(repository: context.read<VhomeRepository>())..add(UsersSubscriptionRequested())),
      ],
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
      body: BlocListener<UsersBloc, UsersState>(
        listenWhen: (previous, current) => 
          previous.status != current.status &&
          current.status == UsersStatus.failure,
        listener: (context, state) =>
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                SnackBar(content: Text("Failed to fetch Users."))
              ),
        child: LayoutBuilder(
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
        ),
      )
    );
  }
}

