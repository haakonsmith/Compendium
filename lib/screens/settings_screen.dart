import 'package:compendium/data/BLoC/settings_bloc.dart';
import 'package:compendium/theme.dart';
import 'package:compendium/widgets/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  static String routeName = '/settings';

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsBloc settingsBloc;

  @override
  Widget build(BuildContext context) {
    settingsBloc = SettingsBloc.of(context, listen: true);

    return Scaffold(
        appBar: AppBar(title: Text("Settings")),
        drawer: NavDrawer(),
        body: Container(
          child: settingsBloc.loading
              ? CompendiumThemeData.of(context).dataLoadingIndicator
              : ListView(
                  children: [
                    SwitchListTile(
                      title: Text(
                        "Dark Theme",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      value: settingsBloc.darkTheme,
                      onChanged: (value) {
                        SettingsBloc.of(context, listen: false).darkTheme =
                            value;
                        setState(() {});
                      },
                    )
                  ],
                ),
        ));
  }
}
