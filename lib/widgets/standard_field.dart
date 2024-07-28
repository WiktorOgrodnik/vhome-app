import 'package:flutter/material.dart';

class StandardFormField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const StandardFormField({
    required this.hintText,
    this.obscureText = false,
    this.onChanged,
    this.errorText,
  });
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      onChanged: onChanged,
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
