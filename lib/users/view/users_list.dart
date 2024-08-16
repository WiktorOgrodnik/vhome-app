import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/task_details/bloc/task_details_bloc.dart';
import 'package:vhome_frontend/users/bloc/users_bloc.dart';
import 'package:vhome_frontend/users/users.dart';
import 'package:vhome_frontend/widgets/widgets.dart';

class UsersList extends StatelessWidget {
  const UsersList({super.key, this.editing = false});

  final bool editing;
  
  @override
  Widget build(BuildContext context) {

    final taskServiceState = editing
        ? context.select((TaskDetailsBloc bloc) => bloc.state)
        : null;

    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        switch (state.status) {
          case UsersStatus.failure:
            return const Text("failed to fetch users.");
          case UsersStatus.success:
            return state.users.isEmpty ?
              const Center(child: Text("No users in this group.")) :
              ListView.separated(
                itemCount: state.users.length,
                separatorBuilder: (context, index) => const Divider(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: UserIcon(MemoryImage(state.users[index].picture), size: 50.0),
                      title: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(state.users[index].username),
                      ),
                      trailing: editing
                        ? Checkbox(
                            value: taskServiceState!
                                      .task
                                      .taskAssigned
                                      .contains(state.users[index].id),
                            onChanged: (value) {
                              context.read<TaskDetailsBloc>().add(TaskAssignUser(
                                user: state.users[index].id,
                                add: value!,
                              ));
                            }
                          )
                        : null,
                    )
                  );
                }
              );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}
