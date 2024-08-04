import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/authentication/bloc/authentication_bloc.dart';
import 'package:vhome_frontend/home/cubit/home_cubit.dart';
import 'package:vhome_frontend/widgets/widgets.dart';

class HomePageDesktop extends StatelessWidget {
  HomePageDesktop({required this.index, required this.child});

  final int index;
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.select((AuthenticationBloc bloc) => bloc.state.data);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 1150,
                backgroundColor: theme.colorScheme.surfaceContainer,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.list),
                    label: Text("Lists"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.devices),
                    label: Text("Devices"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text("Settings"),
                  ),
                ],
                selectedIndex: index,
                onDestinationSelected: (value) {
                  context.read<HomeCubit>().setTab(HomeSubPage.values[value]);
                },
                trailing: Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    width: constraints.maxWidth >= 1150 ? 256 : 80,
                    child: Row(
                      mainAxisAlignment: constraints.maxWidth >= 1150
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: UserProfilePicture(id: user?.id ?? 0, size: 50.0),
                        ),
                        if (constraints.maxWidth >= 1150)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(user?.username ?? "_"),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(child: child),
          ],
        );
      }
    );
  }
}


