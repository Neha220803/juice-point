// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:juice_point/HomeNavPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Users {
  final String displayName;
  final String email;

  Users({
    required this.displayName,
    required this.email,
  });
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              child: SingleChildScrollView(
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
                      onPressed: () async {
                        print(MediaQuery.of(context).size.width);
                        showDialog(
                          context: context,
                          barrierDismissible:
                              false, // Prevents user from dismissing the dialog
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    const Color.fromARGB(255, 247, 243, 243)),
                              ),
                            );
                          },
                        );
                        await signInWithGoogle();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeNavPage()),
                        );
                      },
                      // Call the login method when the button is pressed
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
          ),
        ],
      ),
    );
  }

  Future<Users> signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    UserCredential userCred =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCred.user?.displayName);
    String displayName = userCred.user?.displayName ?? "";
    String email = userCred.user?.email ?? "";

    Users users = Users(
      displayName: displayName,
      email: email,
    );
    return users;
  }
}
