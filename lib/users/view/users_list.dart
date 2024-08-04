import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/users/bloc/users_bloc.dart';
import 'package:vhome_frontend/users/users.dart';
import 'package:vhome_frontend/widgets/widgets.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key, this.task});

  final Task? task;

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  bool get editing => widget.task != null;

  @override
  Widget build(BuildContext context) {

    List<int> taskAssigned = editing 
      ? widget.task!.taskAssigned
      : [];

    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        switch (state.status) {
          case UsersStatus.failure:
            return const Text("failed to fetch users.");
          case UsersStatus.success:
            return state.users.isEmpty ?
              const Center(child: Text("No users in this group.")) :
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                itemCount: state.users.length,
                separatorBuilder: (context, index) => const Divider(),
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
                            value: taskAssigned.contains(state.users[index].id),
                            onChanged: (value) {
                              context.read<UsersBloc>().add(UserTaskAssigned(
                                task: widget.task!,
                                user: state.users[index],
                                value: value!,
                              ));

                              setState(() {
                                if (value) {
                                  taskAssigned.add(state.users[index].id);              
                                } else {
                                  taskAssigned.remove(state.users[index].id);
                                }
                              });
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
