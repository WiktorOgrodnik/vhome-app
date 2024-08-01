import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/authentication/bloc/authentication_bloc.dart';
import 'package:vhome_frontend/widgets/widgets.dart';
import 'package:vhome_repository/vhome_repository.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.data);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20), 
        child: Column(
          children: [
            SizedBox(height: 25),
            UserProfilePicture(id: user?.id ?? 0, size: 150.0),
            SizedBox(height: 25),
            SectionTitle(child: Text(user?.username ?? "_")),
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
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested()),
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
