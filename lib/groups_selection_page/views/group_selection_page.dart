import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_repository/vhome_repository.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

class GroupListTile extends StatefulWidget {
  final Group group;

  const GroupListTile ({
    required this.group,
  });

  @override
  State<StatefulWidget> createState() => GroupListTileState();
}

class GroupListTileState extends State<GroupListTile> {
  @override void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const borderRadius = BorderRadius.all(Radius.circular(8));

    return Material(
      elevation: 4,
      borderRadius: borderRadius,
      child: ListTile(
        leading: null,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        title: Text(widget.group.name),
        tileColor: theme.colorScheme.primary,
        textColor: theme.colorScheme.onPrimary,
        onTap: () =>
          context
            .read<VhomeRepository>()
            .selectGroup(widget.group.id),
      ),
    );
  }
}


class GroupSelectionScreen extends StatefulWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => GroupSelectionScreen());
  }

  @override
    State<StatefulWidget> createState() => GroupSelectionScreenState();
}

class GroupSelectionScreenState extends State<GroupSelectionScreen> {
  late Future<List<Group>> groups;

  @override
  void initState() {
    super.initState();
    groups = context.read<VhomeRepository>().getGroups();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Select group")
      ),
      body: SafeArea(
        child: FutureBuilder<List<Group>>(
          future: groups,
          builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                for (var group in snapshot.data!)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: GroupListTile(
                      group: group,
                    ),
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
