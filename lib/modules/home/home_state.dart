part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class LogOutSuccessfullyState extends HomeState {}
class LogOutErrorState extends HomeState {}
class LogOutLoadingState extends HomeState {}
class state extends HomeState {}

class GetTokenError extends HomeState {}
class GetTokenSuccess extends HomeState {}
class GetTokenLoading extends HomeState {}

class SuccessReadNotification extends HomeState {}

class PickError extends HomeState {}
class PickSuccess extends HomeState {}
class PickLoading extends HomeState {}

class DataStorageError extends HomeState {}
class DataStorageSuccess extends HomeState {}
class DataStorageLoading extends HomeState {}

class DataBaseError extends HomeState {}
class DataBaseSuccess extends HomeState {}
class DataBaseLoading extends HomeState {}

class GetUrlError extends HomeState {}
class GetUrlSuccess extends HomeState {}
class GetUrlLoading extends HomeState {}

class GetNotesError extends HomeState {}
class GetNotesSuccess extends HomeState {}
class GetNotesLoading extends HomeState {}