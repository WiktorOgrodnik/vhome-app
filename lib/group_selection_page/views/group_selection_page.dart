import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/group_selection_page/group_selection_page.dart';
import 'package:vhome_repository/vhome_repository.dart';

class GroupSelectionPage extends StatelessWidget {
  const GroupSelectionPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => GroupSelectionPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupSelectionBloc(repository: context.read<VhomeRepository>())
        ..add(GroupSubscriptionRequested()),
      child: const GroupSelectionView(),
    );
  }
}

class GroupSelectionView extends StatelessWidget {
  const GroupSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select group")
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: const SizedBox(
          width: 1000,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: GroupSelectionList()
              ),
              Text("Or logout now..."),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: _LogoutButton(),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () =>
        context
          .read<VhomeRepository>()
          .logout(),
        child: Text("Logout"),
    );
  }
}
