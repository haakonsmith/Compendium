import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:compendium/data/BLoC/settings_bloc.dart';
import 'package:compendium/data/BLoC/template_bloc.dart';
import 'package:compendium/data/datablock.dart';
import 'package:compendium/routers/instant_page_route.dart';
import 'package:compendium/routers/nested_page_route.dart';
import 'package:compendium/screens/datablock_screen.dart';
import 'package:compendium/screens/index_screen.dart';
import 'package:compendium/screens/settings_screen.dart';
import 'package:compendium/screens/template_screen.dart';
import 'package:compendium/theme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:compendium/data/person.dart';
import 'package:provider/provider.dart';

// For debug purposes
// import 'package:flutter/scheduler.dart' show timeDilation;

var logger = Logger(
  printer: PrettyPrinter(),
);

void main() async {
  // For debug purposes
  // timeDilation = 10.0;

  await Hive.initFlutter("hiveData");

  Hive.registerAdapter(DatablockAdapter());
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(DatablockDisplayStyleAdapter());
  Hive.registerAdapter(DatablockValueStyleAdapter());
  Hive.registerAdapter(DatablockMetadataAdapter());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CompendiumThemeData>(create: (_) => CompendiumThemeData()),
        ChangeNotifierProvider<PersonBloc>(create: (_) => PersonBloc()),
        ChangeNotifierProvider<SettingsBloc>(create: (_) => SettingsBloc()),
        ChangeNotifierProvider<TemplateBloc>(create: (_) => TemplateBloc()),
      ],
      child: CompendiumApp(),
    ),
  );
}

class CompendiumApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CompendiumThemeData.of(context).isDark = SettingsBloc.of(context, listen: true).darkTheme;

    return MaterialApp(
        theme: CompendiumThemeData.of(context).materialTheme,
        title: "Compendium",
        home: IndexScreen(),
        // So look man, this was my solution, I know it mightn't be perfect, but it's not that bad in my opinion
        // combined with the personBloc I think it works
        onGenerateRoute: (settings) {
          if (settings.name == '/index') {
            return InstantPageRoute(builder: (context) => IndexScreen());
          }

          if (settings.name == SettingsScreen.routeName) return InstantPageRoute(builder: (context) => SettingsScreen());
          if (settings.name == TemplateScreen.routeName) return InstantPageRoute(builder: (context) => TemplateScreen());

          // Handle '/person/:index'
          var uriSegments = Uri.parse(settings.name).pathSegments;
          if (uriSegments.first == 'person' && uriSegments.length == 2) {
            var personIndex = int.parse(uriSegments[1]);

            // Set the colour using this... Because otherwise weird stuff
            PersonBloc.of(context).setActivePersonFromIndex(personIndex, color: CompendiumThemeData.of(context, listen: false).materialTheme.primaryColor);

            return NestedPageRoute(builder: (context) => DatablockScreen());
          }

          // index should be the default
          return InstantPageRoute(builder: (context) => IndexScreen());
        });
  }
}
