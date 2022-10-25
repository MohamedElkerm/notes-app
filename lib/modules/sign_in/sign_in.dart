import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase/assets/assets.dart';
import 'package:firebase/modules/home/home_screen.dart';
import 'package:firebase/modules/sign_in/sign_in_cubit.dart';
import 'package:firebase/modules/widgets/shared_widgets.dart';
import 'package:firebase/test.dart';
import 'package:firebase/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(),
      child: BlocConsumer<SignInCubit, SignInState>(
        listener: (context, state) {
          if(state is SignInSuccess){
            navigateToAndReplacement(context,const HomeScreen());
          }
        },
        builder: (context, state) {
          var bloc = BlocProvider.of<SignInCubit>(context);
          return Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: bloc.signInKey,
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(AppAssets().signInAndSignUpImage),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: defaultTextFormField(
                          controller: bloc.emailController,
                          label: 'E-Mail',
                          hintText: 'example@gmail.com',
                          preFixIcon: Icons.email,
                          validator:(value){
                            if(value.length<5){
                              return 'Email is invalid';
                            }else{
                              return null;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: defaultTextFormField(
                          validator:(value){
                            if(value.length<5){
                              return 'password is invalid';
                            }else{
                              return null;
                            }
                          },
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
                            condition: state is SignInLoading,
                            builder: (context)=>const Center(
                              child: CircularProgressIndicator(),
                            ),
                            fallback: (context)=>ElevatedButton(
                              onPressed: () {
                                //TODo: Navigate to home screen
                                bloc.signInWithEmailAndPassword();
                              },
                              child: const Text('SIGN IN'),
                            ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Text('Don\'t have account ?',style:TextStyle(color:AppColors().primary) ,),
                          TextButton(
                              onPressed: () {
                                bloc.navigateToRegister(context);
                              },
                              child:const Text('Register'),
                          )
                        ],
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
