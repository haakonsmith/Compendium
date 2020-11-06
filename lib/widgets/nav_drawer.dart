import 'package:compendium/data/BLoC/screen_bloc.dart';
import 'package:compendium/screens/newIndexScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenBloc screenBloc = Provider.of<ScreenBloc>(context);
    return Container(
      padding: EdgeInsets.all(28.0),
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(28.0)),
        color: Colors.white,
      ),
      child: Drawer(
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.supervisor_account_rounded),
                title: Text('People Index'),
                onTap: () {
                  screenBloc.currentScreen = CurrentScreen.person;
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  screenBloc.currentScreen = CurrentScreen.settings;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
