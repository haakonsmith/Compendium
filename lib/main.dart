import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:compendium/data/BLoC/screen_bloc.dart';
import 'package:compendium/data/datablock.dart';
import 'package:compendium/screens/newIndexScreen.dart';
import 'package:compendium/screens/newPersonScreen.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:compendium/data/person.dart';
import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:provider/provider.dart';

import 'data/theme.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(DatablockAdapter());
  Hive.registerAdapter(PersonAdapter());

  // await Hive.openBox<Map<String, String>>('settings');

  await Hive.openBox<Person>('people');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<PersonBloc>(create: (_) => PersonBloc()),
      //ChangeNotifierProvider<Box<Person>>(create: (_) => Hive.box("people")),
      ChangeNotifierProvider<ScreenBloc>(create: (_) => ScreenBloc(_)),
    ],
    child: CompendiumApp(),
  ));
}

const Map<String, String> defaultSettings = {
  "datablockCounter": "0",
  "theme": "light",
};

class CompendiumApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Compendium",
      theme: ThemeData(
        primarySwatch: CompendiumColors.primaryBlueBlack,
        typography: Typography.material2018(),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => IndexScreen(),
        '/person': (context) => PersonScreen(),
      },
    );
  }
}
