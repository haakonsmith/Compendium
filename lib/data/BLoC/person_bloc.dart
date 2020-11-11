import 'package:compendium/data/datablock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../person.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// It's a change notifier because while it's loading data
class PersonBloc extends ChangeNotifier {
  // This is the active person, basically the person that will be shown on the person screen
  Person _activePerson;

  Box<Datablock> _activePersonBox;

  // This will be true if it's changing from _activePerson = null or _activePerson = a different person
  bool _updating = true;

  // Create the box or open it
  Future<void> setActivePerson(Person person) async {
    _updating = true;
    if (_activePerson != null && Hive.isBoxOpen(_activePerson.databoxID)) {
      if (_activePerson.databoxID.isNotEmpty) {
        await Hive.box<Datablock>(_activePerson.databoxID).close();
      }
    }

    _activePerson = person;
    print(_activePerson);
    print(_activePerson.databoxID);
    _activePersonBox = await Hive.openBox<Datablock>(_activePerson.databoxID);
    _updating = false;
    notifyListeners();
  }

  Future<void> setActivePersonFromIndex(int personIndex) async {
    setActivePerson(Hive.box<Person>("people").getAt(personIndex));
  }

  bool get loading => _updating;

  Person get activePerson {
    if (_updating) return Person.blank();

    return _activePerson;
  }

  Box<Datablock> get activePersonBox {
    if (_updating) return null;

    return _activePersonBox;
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
