import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final Function()? onPressed;

  const ConfirmButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: onPressed,
        child: const Center(
          child: Text(
            "Sign in",
          ),
        ),
      ),
    );
  }
}

