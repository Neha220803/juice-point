// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:juice_point/LoginPage.dart';

class SideNavBar extends StatefulWidget {
  const SideNavBar({super.key});

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  late User? _user;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    setState(() {
      _user = currentUser;
    });
  }

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _user!.photoURL != null
                      ? CircleAvatar(
                          radius: 45, // Adjust the percentage as needed
                          backgroundImage: NetworkImage(_user!.photoURL!),
                        )
                      : CircleAvatar(
                          radius: 45, // Adjust the percentage as needed
                          backgroundColor: Colors
                              .black, // You can set your desired background color
                          child: Text(
                            _user!.displayName![0],
                            style: TextStyle(
                              // Adjust the percentage as needed
                              color: Colors.white,
                            ),
                          ),
                        ),
                  // Adjust the percentage as needed
                  SizedBox(height: 20,),
                  Text(
                    "${_user?.displayName ?? 'No Name'}",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      // Adjust the percentage as needed
                    ),
                  ),
                ],
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
              // print(MediaQuery.of(context).size.width);
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
              await GoogleSignIn().signOut();
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
