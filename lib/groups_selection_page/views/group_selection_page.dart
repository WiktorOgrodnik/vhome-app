import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/authenticate/authenticate.dart';
import 'package:vhome_frontend/models/group.dart';
import 'package:vhome_frontend/service/group.dart';
import 'package:vhome_repository/vhome_repository.dart';

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
    final repository = context.read<VhomeRepository>();
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
        onTap: () => {
          Auth().selectGroup(repository, widget.group.id)
        },
      ),
    );
  }
}


class GroupSelectionScreen extends StatefulWidget {
  @override
    State<StatefulWidget> createState() => GroupSelectionScreenState();
}

class GroupSelectionScreenState extends State<GroupSelectionScreen> {
  late Future<List<Group>> groups;

  @override
  void initState() {
    super.initState();
    groups = GroupService().getGroups(context.read<VhomeRepository>());
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
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
    );
  }
}
