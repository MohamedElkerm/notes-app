import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget signInWithEmailAndPassword(){
  return ElevatedButton(
    onPressed: () async {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: 'mohamedelkerm584@gmail.com', password: '12344321');
      print(userCredential.user!.emailVerified);
      if(!userCredential.user!.emailVerified){
        userCredential.user!.sendEmailVerification();
      }else{
        print('active');
      }
    },
    child: const Text('Sign in with email and password'),
  );
}