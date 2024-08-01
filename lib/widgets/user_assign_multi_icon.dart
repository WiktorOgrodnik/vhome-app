import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/users_bloc/users_bloc.dart';
import 'package:vhome_frontend/widgets/user_icon.dart';

class UserAssignMultiIcon extends StatefulWidget {
  const UserAssignMultiIcon({required this.taskAssignes});

  final List<int> taskAssignes;

  @override
  State<UserAssignMultiIcon> createState() => _UserAssignMultiIconState();
}

class _UserAssignMultiIconState extends State<UserAssignMultiIcon> {
  bool _isHovered = false;
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Stack(
          children: <Widget>[
            for (final (idx, id) in widget.taskAssignes.indexed)
              Positioned(
                top: 7,
                right: ((_isHovered ? 35.0 : 15.0) * idx + 5.0),
                child: BlocBuilder<UsersBloc, UsersState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case UsersStatus.success:
                        final user = state.users.firstWhere((user) => user.id == id); 
                        return Tooltip(
                          message: user.username, 
                          child: UserIcon(MemoryImage(user.picture)),
                        );
                      case UsersStatus.failure:
                        return const Icon(Icons.error);
                      default:
                        return const CircularProgressIndicator();
                        
                    }
                  }
                ),
              )
          ],
        ),
      ),
    );
  }
}


