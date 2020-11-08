import 'package:compendium/data/datablock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../person.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// It's a change notifer because while it's loading data
class PersonBloc extends ChangeNotifier {
  // This is the active person, basically the person that will be shown on the person screen
  Person _activePerson;

  Box<Datablock> _activePersonBox;

  // This will be true if it's chagined from _activePerson = null or _activePerson = a different person
  bool updating = true;

  // Create the box or open it
  Future<void> setActivePerson(Person person) async {
    updating = true;
    _activePerson = person;
    _activePersonBox = await Hive.openBox<Datablock>(_activePerson.databoxID);
    updating = false;
    notifyListeners();
  }

  Future<void> setActivePersonFromIndex(int personIndex) async {
    setActivePerson(Hive.box<Person>("people").getAt(personIndex));
  }

  bool get loading => updating;

  Person get getActivePerson {
    if (updating) {
      return Person.blank();
    }
    return _activePerson;
  }

  ValueListenable<Box<Datablock>> listenForDatablocks() {
    return _activePersonBox.listenable();
  }

  void addDatablockToActivePerson(Datablock datablock) {
    _activePersonBox.add(datablock);
  }

  void addPerson(Person person) {
    Hive.box<Person>("people").add(person);
  }

  static PersonBloc of(BuildContext context, {listen: false}) {
    return Provider.of<PersonBloc>(context, listen: listen);
  }
}
