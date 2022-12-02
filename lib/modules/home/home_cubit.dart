import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase/helper/local/cahche_helper.dart';
import 'package:firebase/modules/sign_in/sign_in.dart';
import 'package:firebase/modules/widgets/shared_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());


  var fbm = FirebaseMessaging.instance;
  var fbm2 = FirebaseMessaging.onMessage;
  var fbm3 = FirebaseMessaging.onMessageOpenedApp;

  initiaMessage()async{
    var msg =await fbm.getInitialMessage();
    if(msg != null){
      signOut(context);
    }
  }
  void buttonNotification(){
    fbm3.listen((event) {
      print("BackGround **************************");
      emit(SuccessReadNotification());
    });
  }
  void getToken(){
    var t;
    emit(GetTokenLoading());
    fbm.getToken().then((value){
      t = value;
      print("token : $value");
      emit(GetTokenSuccess());
    }).catchError((err){
      emit(GetTokenError());
    });
  }
  void readNotificatio()async{
    print('++++++++++++++++++++++++++++++++++++++++++++');
    await fbm2.listen((event) {
       print('**********************************************');
       print(event.notification!.body);
      emit(SuccessReadNotification());
    });
  }

  void signOut(context) {
    emit(LogOutLoadingState());
    FirebaseAuth.instance.signOut().then((value) {
      navigateToAndReplacement(context, const SignInPage());
      CacheHelper.removeData(key: 'uId');
      emit(LogOutSuccessfullyState());
    }).catchError((err) {
      emit(LogOutErrorState());
    });
  }

  var bottomSheetFormKey = GlobalKey<FormState>();
  var noteTitleController = TextEditingController();
  var noteContentController = TextEditingController();
  var noteUrl;
  var path;
  late File picFile;
  var pickImage = ImagePicker();

  showBottomSheetForData(context,stateNow) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      context: context,
      builder: (context) {
        return Form(
          key: bottomSheetFormKey,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: defaultTextFormField(
                        validator: (value) {
                          if (value.length < 4) {
                            return 'invalid name';
                          } else {
                            return null;
                          }
                        },
                        controller: noteTitleController,
                        label: 'Note Title',
                        preFixIcon: Icons.title),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: defaultTextFormField(
                        validator: (value) {
                          if (value.length < 5) {
                            return 'invalid content';
                          } else {
                            return null;
                          }
                        },
                        controller: noteContentController,
                        label: 'Note Content',
                        preFixIcon: Icons.title),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          emit(PickLoading());
                          await pickImage
                              .pickImage(source: ImageSource.gallery)
                              .then((value) {
                            picFile = File(value!.path);
                            path = basename(value.path);
                            emit(PickSuccess());
                          }).catchError((err) {
                            emit(PickError());
                          });
                        },
                        child: const Text('Pick Image'),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (bottomSheetFormKey.currentState!.validate()) {
                            await FirebaseStorage.instance
                                .ref('notes/images/$path')
                                .putFile(picFile)
                                .then((p0) {
                              emit(DataStorageSuccess());
                            }).catchError((err) {
                              emit(DataStorageError());
                            });
                            emit(GetUrlLoading());
                            print('********************------------ $path');
                            await FirebaseStorage.instance
                                .ref('notes/images/$path')
                                .getDownloadURL()
                                .then((value) {
                              noteUrl = value.toString();
                              emit(GetUrlSuccess());
                            }).catchError((err) {
                              print('****************** ${err.toString()}');
                              emit(GetUrlError());
                            });
                            emit(DataBaseLoading());
                            var UID = CacheHelper.getData(key: 'uId');
                            var ref =
                                FirebaseFirestore.instance.collection('notes');
                            ref.add({
                              'note title': noteTitleController.text,
                              'note content': noteContentController.text,
                              'note image url': noteUrl,
                              'uId': UID,
                            }).then((value) {
                              getNotes();
                              emit(DataBaseSuccess());
                            }).catchError((err) {
                              print("*********************{$err.toString()}");
                              emit(DataBaseError());
                            });

                            // await FirebaseFirestore.instance.doc('notes').set({
                            //   'note title':noteTitleController.text,
                            //   'note content':noteContentController.text,
                            //   'note image url':noteUrl,
                            // }).then((value){
                            //   emit(DataBaseSuccess());
                            // }).catchError((err){
                            //   emit(DataBaseError());
                            // });
                          }
                        },
                        child: const Text('save note'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  var noteRef = FirebaseFirestore.instance
      .collection('notes')
      .where('uId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  getNotes() async {
    var UID = CacheHelper.getData(key: 'uId');
    var ref =
        FirebaseFirestore.instance.collection('notes').where({'uId': UID});
    return await ref.get().then((value) {
      emit(GetNotesSuccess());
    }).catchError((err) {
      emit(GetNotesError());
    });
  }

  void getData() async {
    var doc = FirebaseFirestore.instance
        .collection('users')
        .doc('PjvHomGNNt8RFCc6wfLe');
    var res = await doc.get().then((value) {
      print(value.data());
    });
    res.docs.forEach((e) {});
  }

  get() {
    var doc = FirebaseFirestore.instance.collection('users');
    return doc.get();
  }

  showDialogInApp(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            icon: Icon(Icons.highlight),
            title: Text('First Alert'),
            content: Text('First Content For Alert'),
          );
        });
  }

  pushPic() async {
    emit(PickLoading());
    File file;
    var imagePicker = ImagePicker();
    await imagePicker
        .pickImage(source: ImageSource.gallery)
        .then((value) async {
      print(value!.path.toString());
      print('------------------------------');
      file = File(value.path);
      var path = basename(value.path);
      print(path);
      print('------------------------------');
      var refStorage = FirebaseStorage.instance.ref("images/$path");
      await refStorage.putFile(file).then((p0) async {
        var url = await refStorage.getDownloadURL().then((value) {
          print(value.toString());
          emit(PickSuccess());
        }).catchError((err) {
          print('*******************Error in URL');
        });
      }).catchError((err) {
        print('***********Error in REF');
      });
    }).catchError((err) {
      print('***********Error in image picker');
      emit(PickError());
    });
  }

  var bottomSheetFormKeyNoteEdit = GlobalKey<FormState>();
  var noteTitleControllerNoteEdit = TextEditingController();
  var noteContentControllerNoteEdit = TextEditingController();
  var noteEditUrl;
  var pathEditUrl;
  late File picFileEdit;
  var pickImageEdit = ImagePicker();

  showBottomSheetForEditNotes(context,docId) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      context: context,
      builder: (context) {
        return Form(
          key: bottomSheetFormKeyNoteEdit,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: defaultTextFormField(
                        //TODO:Put Right Init Value
                        initValue:null ,
                        validator: (value) {
                          if (value.length < 4) {
                            return 'invalid name';
                          } else {
                            return null;
                          }
                        },
                        controller: noteTitleController,
                        label: 'Note Title',
                        preFixIcon: Icons.title),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: defaultTextFormField(
                        //TODO:Put Right Init Value
                        initValue: null,
                        validator: (value) {
                          if (value.length < 5) {
                            return 'invalid content';
                          } else {
                            return null;
                          }
                        },
                        controller: noteContentController,
                        label: 'Note Content',
                        preFixIcon: Icons.title),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          emit(PickLoading());
                          await pickImage
                              .pickImage(source: ImageSource.gallery)
                              .then((value) {
                            picFile = File(value!.path);
                            path = basename(value.path);
                            emit(PickSuccess());
                          }).catchError((err) {
                            emit(PickError());
                          });
                        },
                        child: const Text('Pick Image'),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (bottomSheetFormKey.currentState!.validate()) {
                            await FirebaseStorage.instance
                                .ref('notes/images/$path')
                                .putFile(picFile)
                                .then((p0) {
                              emit(DataStorageSuccess());
                            }).catchError((err) {
                              emit(DataStorageError());
                            });
                            emit(GetUrlLoading());
                            print('********************------------ $path');
                            await FirebaseStorage.instance
                                .ref('notes/images/$path')
                                .getDownloadURL()
                                .then((value) {
                              noteUrl = value.toString();
                              emit(GetUrlSuccess());
                            }).catchError((err) {
                              print('****************** ${err.toString()}');
                              emit(GetUrlError());
                            });
                            emit(DataBaseLoading());
                            var UID = CacheHelper.getData(key: 'uId');
                            var ref =
                                FirebaseFirestore.instance.collection('notes').doc(docId);
                            ref.update({
                              'note title': noteTitleController.text,
                              'note content': noteContentController.text,
                              'note image url': noteUrl,
                              'uId': UID,
                            }).then((value) {
                              getNotes();
                              emit(DataBaseSuccess());
                            }).catchError((err) {
                              emit(DataBaseError());
                            });

                            // await FirebaseFirestore.instance.doc('notes').set({
                            //   'note title':noteTitleController.text,
                            //   'note content':noteContentController.text,
                            //   'note image url':noteUrl,
                            // }).then((value){
                            //   emit(DataBaseSuccess());
                            // }).catchError((err){
                            //   emit(DataBaseError());
                            // });
                          }
                        },
                        child: const Text('save note'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  deleteNote(uId) async {
    var ref = FirebaseFirestore.instance.collection('notes').doc(uId);
    ref.delete();
  }


}
