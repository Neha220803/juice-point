// ignore_for_file:  avoid_print

import 'package:flutter/material.dart';
import 'package:juice_point/Widgets/custom_font_text.dart';
import 'package:juice_point/Functions/signin_emai_password.dart';
import 'package:juice_point/Models/user_model.dart';
import 'package:juice_point/Pages/home_nav_page.dart';
import 'package:juice_point/Widgets/custom_text_field.dart';
import 'package:juice_point/Widgets/custome_button.dart';
import 'package:juice_point/utils/constants.dart';
import 'package:juice_point/utils/responsive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                            const CustomFontText(
                                value: "Juice Point",
                                color: Color.fromARGB(255, 221, 221, 221),
                                size: 70,
                                fontWeight: FontWeight.w400),
                          SizedBox(
                            width: !responsive.isMobile(context)
                                ? 400
                                : double.infinity,
                            child: CustomTextField(
                                labelText: 'Enter Email ID',
                                errorText: 'Please Enter your email',
                                controller: _emailController),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                              width: !responsive.isMobile(context)
                                  ? 400
                                  : double.infinity,
                              child: CustomTextField(
                                  labelText: "Enter Password",
                                  errorText: "Please enter your Password",
                                  controller: _passwordController)),
                          const SizedBox(height: 20),
                          CustomButton(
                            text: "Login",
                            color: white.withOpacity(0.7),
                            fixedSize: Size(
                                (!responsive.isMobile(context)
                                        ? 400
                                        : MediaQuery.of(context).size.width) -
                                    100,
                                55),
                            callback: () async {
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
                                Users? user = await signInWithEmailAndPassword(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim());
                                Navigator.pop(context);
                                if (user != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeNavPage()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Wrong Email or Password'),
                                      backgroundColor: red,
                                    ),
                                  );
                                }
                              }
                            },
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
}
