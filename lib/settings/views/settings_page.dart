import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/authentication/bloc/authentication_bloc.dart';
import 'package:vhome_frontend/settings/bloc/settings_bloc.dart';
import 'package:vhome_frontend/settings/setting.dart';
import 'package:vhome_frontend/users/bloc/users_bloc.dart';
import 'package:vhome_frontend/users/view/view.dart';
import 'package:vhome_frontend/widgets/widgets.dart';
import 'package:vhome_repository/vhome_repository.dart';

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
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc(repository: context.read<VhomeRepository>()),
      child: const SettingsListener()
    );
  }
}

class SettingsListener extends StatelessWidget {
  const SettingsListener({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SettingsBloc, SettingsState>(
          listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == SettingsStatus.error,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Failed to generate invitation code."),
                ),
              );

            context
              .read<SettingsBloc>()
              .add(SettingsOverviewReturned());
          },
        )
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          switch (state.status) {
            case SettingsStatus.invitation:
              return const SettingsGroupInivitationPage();
            case SettingsStatus.pairingCode:
              return SettingsPairDisplayCodePage();
            case SettingsStatus.pairingQrcode:
              return SettingsPairDisplayPage();
            default:
              return const SettingsView();
          }
        },
      ),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

    
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
          SettingsItem(
            title: "Send invitation code",
            icon: Icons.send,
            onTap: () =>
              context
                .read<SettingsBloc>()
                .add(SettingsInvitationCodeRequested())
          ),
          SettingsItem(
            title: "Leave group",
            icon: Icons.logout,
            onTap: () =>
              context
                .read<AuthenticationBloc>()
                .add(AuthenticationGroupLeaveRequested()),
          ),
        ],
      ),
      SettingsGroup(
        title: "Display",
        items: [
          if (Platform.isAndroid)
          SettingsItem(
            title: "Pair display with the QR code",
            icon: Icons.qr_code,
            onTap: () =>
             context
              .read<SettingsBloc>()
              .add(const SettingsPairDisplayQrcodeRequested())
          ),
          SettingsItem(
            title: "Pair display with the code",
            icon: Icons.display_settings,
            onTap: () =>
             context
              .read<SettingsBloc>()
              .add(const SettingsPairDisplayCodeRequested())
          ),
        ], 
      ),
      SettingsGroup(
        title: "App",
        items: [
          SettingsItem(
            title: "Change group",
            icon: Icons.change_circle_outlined,
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20), 
            child: Column(
              children: [
                SizedBox(height: 25),
                Stack(
                  children: [
                    UserProfilePicture(id: user?.id ?? 0, size: 150.0),
                    Positioned(
                      bottom: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: ShapeDecoration(
                          color: Colors.grey,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          onPressed: () =>
                            context
                              .read<UsersBloc>()
                              .add(UsersUploadProfilePictureRequested()),
                          icon: Icon(Icons.edit_rounded),
                        ),
                      ),
                    )
                  ]),
                SizedBox(height: 25),
                SectionTitle(child: Text(user?.username ?? "_")),
                SizedBox(height: 25),
                SettingsListGroup(settings: settings[0]),
                SizedBox(height: 25),
                SettingsListGroup(settings: settings[1]),
                SizedBox(height: 25),
                SettingsListGroup(settings: settings[2]),
              ],
            ),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
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
                          maxHeight: (constraints.maxWidth < 400
                                      ? 80.0
                                      : 60.0) * settings.items.length,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
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
      ),
    );
  }
}
