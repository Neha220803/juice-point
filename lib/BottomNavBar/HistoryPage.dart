// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:juice_point/BottomNavBar/newOrder.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "~ Order History ~",
            style: TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontFamily: 'Roboto Slab',
              fontWeight: FontWeight.w700,
              letterSpacing: 1.81,
            ),
          ),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              backgroundColor: Color(0xffF5DAD2),
              foregroundColor: Colors.black,
              fixedSize: Size((MediaQuery.of(context).size.width) - 100, 45),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return NewOrderPopUp();
                },
              );
            },
            child: Text(
              "New Order",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            )),
        SizedBox(
          height: 25,
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
    );
  }
}
