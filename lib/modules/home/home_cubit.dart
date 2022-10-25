import 'package:bloc/bloc.dart';
import 'package:firebase/helper/local/cahche_helper.dart';
import 'package:firebase/modules/sign_in/sign_in.dart';
import 'package:firebase/modules/widgets/shared_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void signOut(context){
    emit(LogOutLoadingState());
    FirebaseAuth.instance.signOut().then((value){
      navigateToAndReplacement(context,const SignInPage());
      CacheHelper.removeData(key: 'uId');
      emit(LogOutSuccessfullyState());
    }).catchError((err){
      emit(LogOutErrorState());
    });
  }

}
