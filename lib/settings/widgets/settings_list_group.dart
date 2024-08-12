import 'package:flutter/material.dart';
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
