import 'package:flutter/material.dart';
import 'package:juice_point/utils/constants.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback callback;

  const CustomButton({super.key, required this.text, required this.callback});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.callback,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        widget.text,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
