import 'package:bloc/bloc.dart';
import 'package:firebase/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  UserCredential? userCredential;
  UserModel? userModel;

  void signUp() async {
    emit(SignUpLoading());
    userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
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
      emit(SignUpSuccess());
      return value;
    }).catchError((err){
      emit(SignUpError());
    });
  }
}
