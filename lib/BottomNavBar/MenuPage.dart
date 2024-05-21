// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "~ Menu ~",
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontFamily: 'Roboto Slab',
                fontWeight: FontWeight.w700,
                letterSpacing: 1.81,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                    ),
                    title: Text("Name"),
                    trailing: Text("₹ 85"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
