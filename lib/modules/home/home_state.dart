part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class LogOutSuccessfullyState extends HomeState {}
class LogOutErrorState extends HomeState {}
class LogOutLoadingState extends HomeState {}
