import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/authentication/bloc/authentication_bloc.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

class GroupListTile extends StatelessWidget {
  const GroupListTile({required this.group});

  final Group group;

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
        title: Text(group.name),
        tileColor: theme.colorScheme.primary,
        textColor: theme.colorScheme.onPrimary,
        onTap: () =>
          context
            .read<AuthenticationBloc>()
            .add(AuthenticationGroupSelected(group: group)),
      ),
    );
  }
}
