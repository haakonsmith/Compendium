import 'package:compendium/data/BLoC/template_bloc.dart';
import 'package:compendium/routers/instant_page_route.dart';
import 'package:compendium/screens/template_screen.dart';
import 'package:compendium/theme.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
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
        child: Theme(
          data: Theme.of(context).copyWith(canvasColor: Theme.of(context).scaffoldBackgroundColor),
          child: Drawer(
            elevation: 0,
            child: Container(
              height: 30,
              padding: EdgeInsets.all(0),
              // color: CompendiumThemeData.of(context).materialTheme.scaffoldBackgroundColor,
              color: Colors.transparent,
              child: CompendiumThemeData.of(context).listTileTheme(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.supervisor_account_rounded),
                      title: Text('People Index'),
                      onTap: () =>
                          // Clear the navigation stack so back button doesn't do stuff
                          navigateTo(context, "/index"),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings_applications_rounded),
                      title: Text('Settings'),
                      // Clear the navigation stack so back button doesn't do stuff
                      onTap: () => navigateTo(context, "/settings"),
                    ),
                    ListTile(
                      leading: Icon(Icons.developer_board_rounded),
                      title: Text('DEBUG: reload templates'),
                      // Clear the navigation stack so back button doesn't do stuff
                      onTap: () => navigateTo(context, TemplateScreen.routeName),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
