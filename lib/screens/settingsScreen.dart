import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  static String routeName = '/settings';

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var box = Hive.box("settings");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(children: [
        SwitchListTile(
          title: Text("Dark Theme"),
          value: Provider.of<Box<Map<String, String>>>(context).get(key);
          trailing: Switch,
        ),
      ],),
    
    );}
}
