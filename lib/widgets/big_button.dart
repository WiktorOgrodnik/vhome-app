import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  const BigButton({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;  

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.bodyLarge!;

    return ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: AnimatedSize(
          duration: Duration(milliseconds: 200),
          child: Text(
            label,
            style: style.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
