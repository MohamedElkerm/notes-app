import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget signInWithAnonymousUser(){
  return ElevatedButton(
    onPressed: () async {
      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously().then((value){
        print(value.user!.uid);
        return value;
      });
      print(userCredential);
    },
    child: const Text('sign in with anonymous user'),
  );
}