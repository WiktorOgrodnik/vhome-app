import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/group_selection_page/group_selection_page.dart';
import 'package:vhome_frontend/widgets/widgets.dart';

class GroupSelectionList extends StatelessWidget {
  const GroupSelectionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocBuilder<GroupSelectionBloc, GroupSelectionState>(
            builder: (context, state) {
              switch (state.status) {
                case GroupSelectionStatus.failure:
                  return const Center(child: Text("failed to fetch groups."));
                case GroupSelectionStatus.success:
                  if (state.groups.isEmpty) {
                    return const Center(child: Text("You are not belong to any group."));
                  }
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SectionTitle(
                        child: Text("Your groups"),
                      ),
                      const SizedBox(height: 25),
                      for (var group in state.groups)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: GroupListTile(
                            group: group,
                          ),
                        ),
                    ],
                  );
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
