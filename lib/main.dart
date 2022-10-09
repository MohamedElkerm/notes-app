import 'package:bloc/bloc.dart';
import 'package:firebase/helper/bloc_observer.dart';
import 'package:firebase/modules/sign_in/sign_in.dart';
import 'package:firebase/modules/sign_up/sign_up.dart';
import 'package:firebase/themes/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeApp().themeData,
      home:const SignInPage(),
    );
  }
}

