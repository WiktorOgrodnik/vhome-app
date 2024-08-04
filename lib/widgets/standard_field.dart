import 'package:flutter/material.dart';

class StandardFormField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final String? initialValue;

  const StandardFormField({
    required this.hintText,
    this.obscureText = false,
    this.onChanged,
    this.errorText,
    this.initialValue = "",
  });
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      onChanged: onChanged,
      initialValue: initialValue,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey),
        ),
        fillColor: Colors.grey.shade200,
        filled: true,
        labelText: hintText,
        errorText: errorText,
      ),
    );
  }
}
