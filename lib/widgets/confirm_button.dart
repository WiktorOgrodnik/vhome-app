import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;

  ConfirmButton({
    super.key,
    required this.onPressed,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

