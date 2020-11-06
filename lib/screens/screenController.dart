import 'package:compendium/data/BLoC/screen_bloc.dart';
import 'package:compendium/screens/indexScreen.dart';
import 'package:compendium/screens/newPersonScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenBloc screenBloc = Provider.of<ScreenBloc>(context);

    if (screenBloc.currentScreen == CurrentScreen.person) {
      if (screenBloc.personId != -1) {
        return PersonScreen();
      }
    }
    return IndexScreen();
  }
}
