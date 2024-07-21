import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/authenticate/authenticate.dart';
import 'package:vhome_repository/vhome_repository.dart';

class LogOutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final repository = context.read<VhomeRepository>();
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20), 
        child: Column(
          children: [
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                Auth().unselectGroup(repository);
              },
              child: Text("Change group"),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                Auth().logout(repository);
              },
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
