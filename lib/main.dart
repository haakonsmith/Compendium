import 'package:compendium/BLoC/people_bloc.dart';
import 'package:compendium/widgets/indexscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(CompendiumApp());
}

class CompendiumApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<PeopleBloc>(
      create: (_) => PeopleBloc(),
      child: MaterialApp(
        title: 'moor Demo',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          typography: Typography.material2018(),
        ),
        home: IndexScreen(),
      ),
    );
  }
}
