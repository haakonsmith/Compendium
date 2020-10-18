import 'package:compendium/widgets/indexscreen.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    leading: Icon(Icons.verified_user),
                    title: Text('People Index'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushReplacementNamed(IndexScreen.routeName);
                    },
                  ),
                ],
              )),
        ));
  }
}
