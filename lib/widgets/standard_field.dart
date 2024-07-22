import 'package:flutter/material.dart';

class StandardFormField extends StatelessWidget {
  final FormFieldValidator? validator;
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const StandardFormField({
    required this.controller,
    required this.validator,
    required this.hintText,
    required this.obscureText,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}
