import 'package:compendium/BLoC/people_bloc.dart';
import 'package:compendium/data/model.dart';
import 'package:compendium/widgets/indexscreen.dart';
import 'package:compendium/widgets/person_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(CompendiumApp());
}

class CompendiumApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<CompendiumDatabase>(
      create: (_) => CompendiumDatabase(),
      child: MaterialApp(
          title: 'The Compendium',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            typography: Typography.material2018(),
          ),
          home: IndexScreen(),
          routes: <String, WidgetBuilder>{
            IndexScreen.routeName: (BuildContext context) => IndexScreen()
          }),
    );
  }
}
