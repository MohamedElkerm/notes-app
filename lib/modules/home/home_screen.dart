import 'package:firebase/modules/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is DataBaseSuccess) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final bloc = BlocProvider.of<HomeCubit>(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Notes'),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      bloc.signOut(context);
                    },
                  ),
                )
              ],
            ),
            body: StreamBuilder(
              stream: bloc.noteRef,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                      separatorBuilder: (context, item) {
                        return const Divider(
                          thickness: 2,
                        );
                      },
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, item) {
                        return note(
                            img: snapshot.data!.docs[item].data()['note image url'],
                            title: snapshot.data!.docs[item].data()['note title'],
                            body: snapshot.data!.docs[item].data()['note content'],
                            dissFunc:(DismissDirection dismissDirection){
                              bloc.deleteNote(snapshot.data!.docs[item].id);
                            } ,

                        );
                      });
                } else {
                  return const Center(child:  CircularProgressIndicator());
                }
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                bloc.showBottomSheetForData(context,state);
              },
            ),
          );
        },
      ),
    );
  }
}
