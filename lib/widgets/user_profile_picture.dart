import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/users_bloc/users_bloc.dart';
import 'package:vhome_frontend/widgets/widgets.dart';

class UserProfilePicture extends StatelessWidget {
  const UserProfilePicture({required this.id, required this.size});

  final int id;
  final double size;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (id == 0) {
          return const Icon(Icons.error);
        }

        switch (state.status) {
          case UsersStatus.success:
            final user = state.users.firstWhere((user) => user.id == id); 
            return UserIcon(MemoryImage(user.picture), size: size);
          case UsersStatus.failure:
            return const Icon(Icons.error);
          default:
            return const CircularProgressIndicator();
        }
      }
    );
  }
}
