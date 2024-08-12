import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/authentication/bloc/authentication_bloc.dart';
import 'package:vhome_frontend/settings/setting.dart';
import 'package:vhome_frontend/users/view/view.dart';
import 'package:vhome_frontend/widgets/widgets.dart';
import 'package:vhome_repository/vhome_repository.dart';

class SettingsPageDisplay extends StatelessWidget {
  const SettingsPageDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc(repository: context.read<VhomeRepository>()),
      child: const SettingsViewDisplay()
    );
  }
}

class SettingsViewDisplay extends StatelessWidget {
  const SettingsViewDisplay({super.key});
    
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.data);

    final List<SettingsGroup> settings = [
      SettingsGroup(
        title: "${user?.group} Group",
        items: [
          SettingsItem(
            title: "Group users",
            icon: Icons.contacts,
            onTap: () => 
              Navigator.of(context).push(
                UsersPage.route()
              ),
          ),
        ],
      ),
      SettingsGroup(
        title: "Display",
        items: [
          SettingsItem(
            title: "Unpair display",
            icon: Icons.settings_display,
            onTap: () =>
              context
                .read<AuthenticationBloc>()
                .add(AuthenticationLogoutRequested())
          ),
        ], 
      ),
    ];

    return Container(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 1000,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20), 
            child: Column(
              children: [
                SizedBox(height: 50),
                SectionTitle(child: Text("Display")),
                SizedBox(height: 25),
                SettingsListGroup(settings: settings[0]),
                SizedBox(height: 25),
                SettingsListGroup(settings: settings[1]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
