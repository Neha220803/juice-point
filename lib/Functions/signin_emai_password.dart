// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:juice_point/Models/user_model.dart';

Future<Users?> signInWithEmailAndPassword(
    emailController, passwordController) async {
  try {
    final FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential userCred = await auth.signInWithEmailAndPassword(
      email: emailController,
      password: passwordController,
    );
    String displayName = userCred.user?.displayName ?? "";
    String email = userCred.user?.email ?? "";

    Users users = Users(
      displayName: displayName,
      email: email,
    );
    return users;
  } catch (e) {
    // print('Error in sing in: $e');
    return null;
  }
}
