// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:juice_point/HomeNavPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Method to handle the login with Google
  void _loginWithGoogle() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeNavPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login-bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Logo at the top
          // Positioned(
          //   top: 70, // Adjust position as needed
          //   left: 0,
          //   right: 220,
          //   child: Center(
          //     child: Image.asset(
          //       'assets/logo.png', // Replace 'your_logo.png' with your actual logo image asset
          //       height: 100, // Adjust height as needed
          //     ),
          //   ),
          // ),
          // Login button with Google
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 240),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      fixedSize:
                          Size((MediaQuery.of(context).size.width) - 100, 45),
                    ),
                    onPressed:
                        _loginWithGoogle, // Call the login method when the button is pressed
                    icon: Image.asset(
                      'assets/g.png',
                      height: 24.0, // Adjust the height as needed
                    ),
                    label: Text(' Login with Google'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
