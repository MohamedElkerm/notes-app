part of 'sign_up_cubit.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}
class SignUpSuccess extends SignUpState {}
class SignUpError extends SignUpState {}


