import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase/modules/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_cubit.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getToken()..readNotificatio()..buttonNotification()..initiaMessage()..getNotes(),
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
            body: ConditionalBuilder(
              condition: state is GetNotesSuccess,
              builder: (context)=>ListView.separated(
                  separatorBuilder: (context, item) {
                    return const Divider(
                      thickness: 2,
                    );
                  },
                  itemCount: bloc.notes.length,
                  itemBuilder: (context, item) {
                    return note(
                      img: bloc.notes[item]['note image url'],
                      title: bloc.notes[item]['note title'],
                      body: bloc.notes[item]['note content'],
                      dissFunc:(DismissDirection dismissDirection){
                        bloc.deleteNote(bloc.notes[item].id);
                      } ,

                    );
                  }),
              fallback: (context)=>const Center(child: CircularProgressIndicator()),
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
