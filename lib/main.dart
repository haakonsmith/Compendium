import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:compendium/data/datablock.dart';
import 'package:compendium/screens/indexScreen.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:compendium/data/person.dart';
import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:provider/provider.dart';

import 'theme.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(DatablockAdapter());

  var settingsBox = await Hive.openBox<Map<String, String>>('settings');

  await Hive.openBox<Person>('people');

  runApp(MultiProvider(
    providers: [
      Provider<PersonBloc>(create: (_) => PersonBloc()),
      Provider<Box<Person>>(
        create: (_) => Hive.box("people"),
      )
    ],
    child: CompendiumTheme(child: CompendiumApp()),
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
      theme: context.appTheme.materialTheme,
      home: IndexScreen(),
    );
  }
}
