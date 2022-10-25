import 'package:bloc/bloc.dart';
import 'package:firebase/helper/bloc_observer.dart';
import 'package:firebase/helper/local/cahche_helper.dart';
import 'package:firebase/modules/home/home_screen.dart';
import 'package:firebase/modules/sign_in/sign_in.dart';
import 'package:firebase/themes/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
Widget startPoint =const SignInPage();

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();
  CacheHelper.getData(key: 'uId')!=null?startPoint =const HomeScreen():startPoint =const SignInPage();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeApp().themeData,
      home:startPoint,
    );
  }
}

