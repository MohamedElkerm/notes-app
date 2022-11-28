import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/helper/local/cahche_helper.dart';
import 'package:firebase/models/user_model.dart';
import 'package:firebase/modules/widgets/shared_data.dart';
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
  var signUpKey = GlobalKey<FormState>();

  void signUp() async {
    emit(SignUpLoading());
    if(signUpKey.currentState!.validate()){
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
        CacheHelper.saveData(key: 'uId', value: userModel!.uId);
        saveUserData(userModel!.uId);
        emit(SignUpSuccess());
        return value;
      }).catchError((err){
        emit(SignUpError());
      });
    }else{
      emit(SignUpError());
    }
  }

  void saveUserData(uIdValue){
    emit(SetUserDataLoading());
    FirebaseFirestore.instance.doc('users/$uIdValue').set({
      'name':nameController.text,
      'phone':phoneController.text,
      'email':emailController.text,
      'password':passwordController.text,
    }).then((value){
      emit(SetUserDataSuccess());
    }).catchError((err){
      print('*************************** ${err.toString()}');
      emit(SetUserDataError());
    });
  }
}
