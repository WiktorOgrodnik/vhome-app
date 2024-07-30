
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/home/cubit/home_cubit.dart';

class HomePageMobile extends StatelessWidget {
  HomePageMobile({required this.child, required this.index});
 
  final int index;
  final Widget child;
    
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: child),
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
            currentIndex: index,
            onTap: (value) {
              context.read<HomeCubit>().setTab(HomeSubPage.values[value]);
            },
          )
        )
      ],
    );
  }
}
