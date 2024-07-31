// ignore_for_file: prefer_const_constructors
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:juice_point/Pages/login_page.dart';
import 'package:juice_point/firebase_options.dart';
import 'package:juice_point/utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: green,
          ),
          dialogTheme: DialogTheme(
            backgroundColor: Colors.white,
          ),
          scaffoldBackgroundColor: white,
          primarySwatch: green),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      // initialRoute: "/",
      // routes: {
      //   '/': (context) => LoginPage(),
      //   '/login': (context) => const LoginPage(),
      //   '/logout': (context) => const HomeNavPage(),
      // },
    );
  }
}
