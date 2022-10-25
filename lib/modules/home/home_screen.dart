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
      child:BlocConsumer<HomeCubit,HomeState>(
        listener: (context , state ){},
        builder: (context , state ){
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
            body: ListView.separated(
                separatorBuilder: (context, item) {
                  return const Divider(
                    thickness: 2,
                  );
                },
                itemCount: 20,
                itemBuilder: (context, item) {
                  return note();
                }),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {},
            ),
          );
        },
      ),
    );
  }
}
