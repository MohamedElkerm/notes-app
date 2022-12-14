import 'package:bloc/bloc.dart';
import 'package:firebase/helper/local/cahche_helper.dart';
import 'package:firebase/models/user_model.dart';
import 'package:firebase/modules/sign_up/sign_up.dart';
import 'package:firebase/modules/widgets/shared_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var signInKey = GlobalKey<FormState>();


  void navigateToRegister(context) {
    navigateTo(context, const SignUpPage());
  }

  UserCredential? userCredential;
  UserModel? userModel;

  void signInWithEmailAndPassword() async {
    emit(SignInLoading());
    if(signInKey.currentState!.validate()){
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((value) {
        userModel = UserModel(
          value.user!.email.toString(),
          value.user!.displayName.toString(),
          value.user!.phoneNumber.toString(),
          value.user!.uid.toString(),
        );
        CacheHelper.saveData(key: 'uId',value: userModel!.uId);
        print('success');
        emit(SignInSuccess());
        return value;
      }).catchError((err) {
        emit(SignInError(err.toString()));
      });
    }else{
      emit(SignInError('error'));
    }
  }
}
