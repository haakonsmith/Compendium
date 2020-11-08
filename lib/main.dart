import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:compendium/data/BLoC/settings_bloc.dart';
import 'package:compendium/data/datablock.dart';
import 'package:compendium/screens/indexScreen.dart';
import 'package:compendium/screens/personScreen.dart';
import 'package:compendium/screens/settingsScreen.dart';
import 'package:compendium/theme.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:compendium/data/person.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter("hiveData");

  Hive.registerAdapter(DatablockAdapter());
  Hive.registerAdapter(PersonAdapter());

  await Hive.openBox<Person>('people');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CompendiumThemeData>(
            create: (_) => CompendiumThemeData()),
        ChangeNotifierProvider<PersonBloc>(create: (_) => PersonBloc()),
        ChangeNotifierProvider<SettingsBloc>(create: (_) => SettingsBloc())
      ],
      child: CompendiumApp(),
    ),
  );
}

class CompendiumApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CompendiumThemeData.of(context).isDark =
        SettingsBloc.of(context, listen: true).darkTheme;

    return MaterialApp(
        theme: CompendiumThemeData.of(context).materialTheme,
        title: "Compendium",
        home: IndexScreen(),
        // So look man, this was my solution, I know it mightn't be perfect, but it's not that bad in my opinion
        // combined with the personBloc I think it works
        onGenerateRoute: (settings) {
          if (settings.name == '/index') {
            return MaterialPageRoute(builder: (context) => IndexScreen());
          }

          if (settings.name == "/settings") {
            return MaterialPageRoute(builder: (context) => SettingsScreen());
          }

          // Handle '/person/:index'
          var uri = Uri.parse(settings.name);
          if (uri.pathSegments.length == 2 &&
              uri.pathSegments.first == 'person') {
            var index = int.parse(uri.pathSegments[1]);
            PersonBloc.of(context).setActivePersonFromIndex(index);
            return MaterialPageRoute(builder: (context) => PersonScreen());
          }

          // TODO: Implement [UnknownScreen]
          // return MaterialPageRoute(builder: (context) => UnknownScreen());
        });
  }
}
