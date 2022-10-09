import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget registerWithEmailAndPassword() {
  return ElevatedButton(
    onPressed: () async {
      UserCredential userCredential =await FirebaseAuth.instance.createUserWithEmailAndPassword(email: 'mohamedelkerm584@gmail.com', password: '12344321').then((value){
        return value;
      });
      print(userCredential.user!.phoneNumber);
      print(userCredential.user!.email);
    },
    child: const Text('Register with email and password'),
  );
}
