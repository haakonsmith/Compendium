import 'dart:async';

import 'package:compendium/BLoC/bloc.dart';
import 'package:compendium/data/model.dart';
import 'package:moor/moor.dart';

class AcademicProfileBloc implements Bloc {
  final CompendiumDatabase db;

  Stream<List<AcademicProfile>> _currentProfiles;

  AcademicProfileBloc(CompendiumDatabase database) : db = database {
    // listen for the category to change. Then display all entries that are in
    // the current category on the home screen.
    // _currentPeople = db.watchAllPeople;
  }
}
