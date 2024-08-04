import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/users/bloc/users_bloc.dart';
import 'package:vhome_frontend/users/view/users_list.dart';
import 'package:vhome_repository/vhome_repository.dart';

class UsersPage extends StatelessWidget {
  const UsersPage ({super.key});
  
  static Route<void> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => UsersPage(),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersBloc(
        repository: context.read<VhomeRepository>() ,
      )..add(UsersSubscriptionRequested()),
      child: const UsersView(),
    );
  }
}

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: SizedBox(
            width: 1000,
            child: UsersList(),
          ),
        ),
      ),
    );
  }
}
