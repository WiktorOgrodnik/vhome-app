import 'package:flutter/material.dart';

class ElevatedContainer extends StatelessWidget {
  const ElevatedContainer({
    this.elevation = 0.0,
    this.color,
    required this.child,
  });
  
  final double elevation;
  final Color? color;
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      color: color,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: child,
    );
  }
}
