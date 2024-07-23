import 'package:flutter/material.dart';
import 'package:vhome_frontend/devices_page/view/devices_page.dart';
import 'package:vhome_frontend/settings/views/views.dart';
import 'package:vhome_frontend/tasksets_page/view/view.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = TasksetsPage();
      case 1:
        page = DevicesPage();
      case 2:
        page = LogOutPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    
    return LayoutBuilder(
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
                  currentIndex: selectedIndex,
                  onTap: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
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
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  }
                ),
              ),
              Expanded(child: page),
            ],
          );
        }
      }
    );
  }
}

