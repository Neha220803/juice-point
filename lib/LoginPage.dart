// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:juice_point/HomeNavPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:juice_point/utils/responsive.dart';

class Users {
  final String displayName;
  final String email;

  Users({
    required this.displayName,
    required this.email,
  });
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login-bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          if (!responsive.isMobile(context))
                            Text('Juice Point',
                                style: GoogleFonts.pacifico(
                                  textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 221, 221, 221),
                                    fontSize: 70,
                                    fontFamily: 'Pacifico',
                                    fontWeight: FontWeight.w400,
                                  ),
                                )),
                          SizedBox(
                            width: !responsive.isMobile(context)
                                ? 400
                                : double.infinity,
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Enter Email ID',
                                border: const OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.5),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: !responsive.isMobile(context)
                                ? 400
                                : double.infinity,
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Enter Password',
                                border: const OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.5),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              backgroundColor: Colors.white.withOpacity(0.7),
                              foregroundColor: Colors.black,
                              fixedSize: Size(
                                  (!responsive.isMobile(context)
                                          ? 400
                                          : MediaQuery.of(context).size.width) -
                                      100,
                                  45),
                            ),
                            onPressed: () async {
                              // Validate the form before proceeding
                              if (_formKey.currentState!.validate()) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            Color.fromARGB(255, 247, 243, 243)),
                                      ),
                                    );
                                  },
                                );
                                Users? user =
                                    await signInWithEmailAndPassword();
                                Navigator.pop(
                                    context); // Close the progress dialog
                                if (user != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeNavPage()),
                                  );
                                } else {
                                  // Show error message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Wrong Email or Password'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Users?> signInWithEmailAndPassword() async {
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      String displayName = userCred.user?.displayName ?? "";
      String email = userCred.user?.email ?? "";

      Users users = Users(
        displayName: displayName,
        email: email,
      );
      return users;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
