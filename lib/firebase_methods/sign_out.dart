import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget signOut(){
  return ElevatedButton(
    onPressed: () async {
      await FirebaseAuth.instance.signOut();
    },
    child: const Text('Sign Out'),
  );
}