import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_repository/vhome_repository.dart';

class LogOutPage extends StatelessWidget {
  const LogOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20), 
        child: Column(
          children: [
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () =>
                context
                  .read<VhomeRepository>()
                  .unselectGroup(),
              child: Text("Change group"),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () =>
                context
                  .read<VhomeRepository>()
                  .logout(),
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
