import 'package:flutter/material.dart';
import 'package:vhome_frontend/authenticate/authenticate.dart';
import 'package:vhome_frontend/groups_selection_page/views/views.dart';
import 'package:vhome_frontend/home/view/view.dart';
import 'package:vhome_frontend/views/login.dart';

class AuthGuard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Auth().authState$,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == AuthState.pending) {
          return Center(child: CircularProgressIndicator());
        }
        switch (snapshot.data) {
          case AuthState.unauthenticated:
            return LoginScreen();
          case AuthState.groupUnselected:
            return GroupSelectionScreen();
          case AuthState.groupSelected:
            return HomePage();
          default:
            return CircularProgressIndicator();
        }
      }
    ); 
  }
}

