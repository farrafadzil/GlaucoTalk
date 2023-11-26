import 'package:apptalk/firebase/login_or_registration.dart';
import 'package:apptalk/main.dart';
import 'package:apptalk/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user logged in
          if (snapshot.hasData) {
            return HomePage();
          }
          // user not logged in
          else {
            return LoginOrRegister();
          }
        },
      ),
    );
  }

}

