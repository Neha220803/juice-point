import 'package:flutter/material.dart';
import 'package:juice_point/utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String errorText;
  final TextEditingController controller;

  const CustomTextField(
      {super.key,
      required this.labelText,
      required this.errorText,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
        filled: true,
        fillColor: white.withOpacity(0.5),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return errorText;
        }
        return null;
      },
    );
  }
}
