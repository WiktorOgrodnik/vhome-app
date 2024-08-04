import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/accept_invitation/view/view.dart';
import 'package:vhome_frontend/add_group/view/view.dart';
import 'package:vhome_frontend/group_selection_page/group_selection_page.dart';
import 'package:vhome_frontend/widgets/big_button.dart';
import 'package:vhome_frontend/widgets/section_title.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: 1000,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: SectionTitle(child: Text("Do you have an invitation code?", textAlign: TextAlign.center)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: BigButton(
                    label: "Join existing group",
                    onPressed: () =>
                      Navigator.of(context).push(
                        AcceptInivitationPage.route()
                      ),
                  ),
                ),
                const Divider(),
                const Expanded(
                  flex: 2,
                  child: GroupSelectionList()
                ),
                const Text("Create new group"),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: _CreateGroupButton(),
                ),
                const Text("...or logout now"),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: _LogoutButton(),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}

class _CreateGroupButton extends StatelessWidget {
  const _CreateGroupButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () =>
        Navigator.of(context).push(
          AddGroupPage.route()
        ),
      child: Text("New group"),
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
