import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:compendium/data/BLoC/screen_bloc.dart';
import 'package:compendium/data/datablock.dart';
import 'package:compendium/screens/newIndexScreen.dart';
import 'package:compendium/screens/newPersonScreen.dart';
import 'package:compendium/screens/screenController.dart';
import 'package:compendium/theme.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:compendium/data/person.dart';
import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter("hiveData");

  Hive.registerAdapter(DatablockAdapter());
  Hive.registerAdapter(PersonAdapter());

  var settingsBox = await Hive.openBox('settings');

  settingsBox.put

  // print(await Hive.boxExists('people'));
  // await Hive.deleteFromDisk();
  // print(await Hive.boxExists('people'));
  // await Hive.deleteBoxFromDisk('people');
  // print(await Hive.boxExists('people'));

  await Hive.openBox<Person>('people');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CompendiumThemeData>(create: (_) => CompendiumThemeData()),
        ChangeNotifierProvider<ScreenBloc>(create: (_) => ScreenBloc()),
      ],
      child: CompendiumApp(),
    ),
  );
}

const Map<String, String> defaultSettings = {
  "datablockCounter": "0",
  "theme": "light",
};

class CompendiumApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CompendiumThemeData.of(context).materialTheme,
      title: "Compendium",
      home: ScreenController(),
    );
  }
}
