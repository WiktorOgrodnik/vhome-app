
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/authentication/bloc/authentication_bloc.dart';
import 'package:vhome_frontend/users/view/view.dart';
import 'package:vhome_frontend/widgets/widgets.dart';

class SettingsItem {
  const SettingsItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final GestureTapCallback? onTap;
}

class SettingsGroup {
  const SettingsGroup({
    required this.title,
    this.items = const [],
  });

  final String title;
  final List<SettingsItem> items;
}

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.data);

    final List<SettingsGroup> settings = [
      SettingsGroup(
        title: "Your Group",
        items: [
          SettingsItem(
            title: "Group users",
            icon: Icons.verified_user,
            onTap: () => 
              Navigator.of(context).push(
                UsersPage.route()
              ),
          )
        ]
      ),
      SettingsGroup(
        title: "App",
        items: [
          SettingsItem(
            title: "Change group",
            icon: Icons.change_circle,
            onTap: () =>
              context
                .read<AuthenticationBloc>()
                .add(AuthenticationGroupUnselectionRequested()),
          ),
          SettingsItem(
            title: "Logout",
            icon: Icons.logout,
            onTap: () =>
              context
                .read<AuthenticationBloc>()
                .add(AuthenticationLogoutRequested()),
          ),
        ],
      ),
    ];

    return Container(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 1000,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20), 
          child: Column(
            children: [
              SizedBox(height: 25),
              UserProfilePicture(id: user?.id ?? 0, size: 150.0),
              SizedBox(height: 25),
              SectionTitle(child: Text(user?.username ?? "_")),
              SizedBox(height: 25),
              SettingsListGroup(settings: settings[0]),
              SizedBox(height: 25),
              SettingsListGroup(settings: settings[1]),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsListGroup extends StatelessWidget {
  const SettingsListGroup({
    super.key,
    required this.settings,
  });

  final SettingsGroup settings;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: Colors.transparent,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(20)), 
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.all(Radius.circular(20)), 
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                SectionTitle(child: Container(alignment: Alignment.topLeft, child: Text(settings.title))),
                SizedBox(height: 20),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 60.0 * settings.items.length, 
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.separated(
                      itemCount: settings.items.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        return ElevatedContainer(
                          color: Colors.grey[100],
                          child: ListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                            hoverColor: Colors.grey[250],
                            leading: Icon(settings.items[index].icon),
                            title: Text(settings.items[index].title),
                            trailing: Icon(Icons.arrow_right),
                            onTap: settings.items[index].onTap,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*ElevatedButton(
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
            ),*/
