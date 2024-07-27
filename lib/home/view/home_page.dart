import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/devices_page/view/view.dart';
import 'package:vhome_frontend/home/cubit/home_cubit.dart';
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

    final Widget page = 
      IndexedStack(
        index: selectedPage.index,
        children: const [
          TasksetsPage(),
          DevicesPage(),
          LogOutPage(),
        ]
      );

    return Scaffold(
      appBar: AppBar(
        title: Text("Vhome"),
        backgroundColor: theme.colorScheme.surfaceContainer,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 500) {
            return Column(
              children: [
                Expanded(child: page),
                SafeArea(
                  child: BottomNavigationBar(
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: "Home",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.devices),
                        label: "Devices",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.exit_to_app),
                        label: "Logout",
                      ),
                    ],
                    currentIndex: selectedPage.index,
                    onTap: (value) {
                      context.read<HomeCubit>().setTab(HomeSubPage.values[value]);
                    },
                  )
                )
              ],
            );
          } else {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 1150,
                    backgroundColor: theme.colorScheme.surfaceContainer,
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
                    selectedIndex: selectedPage.index,
                    onDestinationSelected: (value) {
                      context.read<HomeCubit>().setTab(HomeSubPage.values[value]);
                    }
                  ),
                ),
                Expanded(child: page),
              ],
            );
          }
        }
      )
    );
  }
}

