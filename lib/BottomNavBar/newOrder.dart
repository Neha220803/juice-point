// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class NewOrderPopUp extends StatefulWidget {
  const NewOrderPopUp({super.key});

  @override
  State<NewOrderPopUp> createState() => _NewOrderPopUpState();
}

class _NewOrderPopUpState extends State<NewOrderPopUp> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Text("data"),
    );
  }
}
