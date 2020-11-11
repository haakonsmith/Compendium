import 'package:compendium/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatelessWidget {
  NavDrawer();

  void navigateTo(BuildContext context, String path) {
    Navigator.of(context).pushNamedAndRemoveUntil(path, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(28.0),
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        borderRadius: CompendiumThemeData.of(context).borderRadius,
        color: CompendiumThemeData.of(context).materialTheme.scaffoldBackgroundColor,
      ),
      child: Drawer(
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            color: CompendiumThemeData.of(context).materialTheme.scaffoldBackgroundColor,
          ),
          child: CompendiumThemeData.of(context).listTileTheme(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.supervisor_account_rounded),
                  title: Text('People Index'),
                  onTap: () =>
                      // Clear the navigation stack so back button doesn't do stuff
                      navigateTo(context, "/index"),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  // Clear the navigation stack so back button doesn't do stuff
                  onTap: () => navigateTo(context, "/settings"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
