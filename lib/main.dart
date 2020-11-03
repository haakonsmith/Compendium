import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:compendium/data/datablock.dart';
import 'package:compendium/screens/indexScreen.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:compendium/data/person.dart';
import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:provider/provider.dart';

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
    child: CompendiumApp(),
  ));
}

MaterialColor primaryBlueBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFFe4e9ec),
    100: Color(0xFFbac7d3),
    200: Color(0xFF8fa3b5),
    300: Color(0xFF667f97),
    400: Color(0xFF446584),
    500: Color(0xFF1c4d73),
    600: Color(0xFF14466b),
    700: Color(0xFF0a3d61),
    800: Color(_blackPrimaryValue),
    900: Color(0xFF07233c),
  },
);
const int _blackPrimaryValue = 0xFF063354;

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
        primarySwatch: primaryBlueBlack,
        typography: Typography.material2018(),
      ),
      home: IndexScreen(),
    );
  }
}
