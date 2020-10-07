import 'dart:async';

import 'package:compendium/BLoC/bloc.dart';
import 'package:compendium/data/model.dart';
import 'package:moor/moor.dart';
import 'package:rxdart/rxdart.dart';

class PersonData {
  final String firstName;

  PersonData({this.firstName});
}

// TODO I think I need to dipose this, but not right now and I don't know how to
// A bloc for the people overview
class PeopleBloc implements Bloc {
  final CompendiumDatabase db;

  Stream<List<Person>> _currentPeople;

  /// A stream of People that should be displayed on the home screen.
  Stream<List<Person>> get homeScreenPeople => _currentPeople;

  PeopleBloc() : db = CompendiumDatabase() {
    // listen for the category to change. Then display all entries that are in
    // the current category on the home screen.
    _currentPeople = db.watchAllPeople;
  }

  void addPerson(PersonData person) {
    db.addPerson(PeopleCompanion(firstName: Value(person.firstName)));
  }

  @override
  void dispose() {
    // _personController.close();
  }
}
