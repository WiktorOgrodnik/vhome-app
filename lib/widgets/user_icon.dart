import 'package:flutter/material.dart';

class UserIcon extends StatelessWidget {
  const UserIcon(this.imageProvider, {this.size = 32.0});
  
  final ImageProvider? imageProvider;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2 - 2.0),
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
