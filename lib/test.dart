import 'package:firebase/firebase_methods/anonymous/sign_in_anonymous.dart';
import 'package:firebase/firebase_methods/email_and_password/register_with_email_and_password.dart';
import 'package:firebase/firebase_methods/email_and_password/sign_in.dart';
import 'package:firebase/firebase_methods/sign_out.dart';
import 'package:firebase/firebase_methods/with_google/sign_in_with_google.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            signInWithAnonymousUser(),
            registerWithEmailAndPassword(),
            signInWithEmailAndPassword(),
            signInWithGoogle(),
            signOut(),
          ],
        ),
      ),
    );
  }
}
