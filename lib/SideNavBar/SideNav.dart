// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:juice_point/LoginPage.dart';
import 'package:juice_point/utils/responsive.dart';

class SideNavBar extends StatefulWidget {
  const SideNavBar({super.key});

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Color(0xff75A47F),
            child: DrawerHeader(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage("assets/logo.png"),
                    ),
                    // Adjust the percentage as neede
                    Text(
                      "Juice Point",
                      style: TextStyle(
                        fontSize: !responsive.isMobile(context)
                            ? 25
                            : MediaQuery.of(context).size.width / 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        // Adjust the percentage as needed
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Stock Requests'),
            onTap: () {
              print(MediaQuery.of(context).size.width);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => NotifyPage()),
              // );
            },
          ),
          //  Divider(),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text("Log Out"),
            onTap: () async {
              // await GoogleSignIn().signOut();
              FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          )
        ],
      ),
    ));
  }
}
