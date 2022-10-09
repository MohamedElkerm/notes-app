part of 'sign_in_cubit.dart';

@immutable
abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}
class SignInSuccess extends SignInState {}
class SignInError extends SignInState {
  String error;
  SignInError(this.error);
}