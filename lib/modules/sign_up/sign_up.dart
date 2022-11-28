import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase/assets/assets.dart';
import 'package:firebase/modules/home/home_screen.dart';
import 'package:firebase/modules/sign_up/sign_up_cubit.dart';
import 'package:firebase/modules/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if(state is SignUpSuccess){
            navigateToAndReplacement(context,const HomeScreen());
          }
        },
        builder: (context, state) {
          var bloc = BlocProvider.of<SignUpCubit>(context);
          return Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: bloc.signUpKey,
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(AppAssets().signInAndSignUpImage),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: defaultTextFormField(
                          validator:(value){
                            if(value.length<5){
                              return 'Name is too short';
                            }else{
                              return null;
                            }
                          },
                          //controller: bloc.emailController,
                          controller: bloc.nameController,
                          label: 'Name',
                          hintText: 'Mohamed',
                          preFixIcon: Icons.person,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: defaultTextFormField(
                          validator:(value){
                            if(value.length<5){
                              return 'Phone is invalid';
                            }else{
                              return null;
                            }
                          },
                          //controller: bloc.passwordController,
                          controller: bloc.phoneController,
                          label: 'phone',
                          hintText: '+20**********',
                          preFixIcon: Icons.phone_android,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: defaultTextFormField(
                          validator:(value){
                            if(value.length<5){
                              return 'Email is invalid';
                            }else{
                              return null;
                            }
                          },
                          //controller: bloc.emailController,
                          controller: bloc.emailController,
                          label: 'E-Mail',
                          hintText: 'example@gmail.com',
                          preFixIcon: Icons.email,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: defaultTextFormField(
                          validator:(value){
                            if(value.length<5){
                              return 'Password is invalid';
                            }else{
                              return null;
                            }
                          },
                          //controller: bloc.passwordController,
                          controller: bloc.passwordController,
                          label: 'Password',
                          hintText: '1234',
                          preFixIcon: Icons.lock,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 375,
                        child: ConditionalBuilder(
                          condition: state is SignUpLoading,
                          builder: (context)=>const Center(child: CircularProgressIndicator(),) ,
                          fallback: (context)=> ElevatedButton(
                            onPressed: () {
                              //TODo: Navigate to home screen
                              bloc.signUp();
                            },
                            child: const Text('SIGN UP'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
