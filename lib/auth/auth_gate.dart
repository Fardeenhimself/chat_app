import 'package:chat_app/auth/login_or_register.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // if user logged in, show home page
          if () {
            return HomePage();
          }
          // else show the login or register page
          else {
            return LoginOrRegister();
          }
        },
      ),
    );
  }
}
