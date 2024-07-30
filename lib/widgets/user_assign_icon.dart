import 'package:flutter/material.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

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
                child: UserAssignIcon(
                  imageProvider: NetworkImage("$apiUrl/user/$id/picture"))
              )
          ],
        ),
      ),
    );
  }
}

class UserAssignIcon extends StatelessWidget {
  const UserAssignIcon({this.imageProvider});

  final ImageProvider? imageProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
        boxShadow: [
          const BoxShadow(
            blurRadius: 0.5,
            color: Colors.grey,
          )
        ]
      ),
      child: CircleAvatar(
        backgroundImage: imageProvider,
      ),
    );
  }
}
