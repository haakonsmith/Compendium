import 'package:compendium/data/datablock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../person.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PersonBloc extends ChangeNotifier {
  // This is the active person, basically the person that will be shown on the person screen
  Person _activePerson;

  Box<Datablock> _activePersonBox;

  // Create the box or open it
  Future<void> setActivePerson(Person person) async {
    _activePerson = person;
    _activePersonBox = await Hive.openBox<Datablock>(_activePerson.databoxID);
  }

  Future<void> setActivePersonFromIndex(int personIndex) async {
    setActivePerson(Hive.box<Person>("people").getAt(personIndex));
  }

  Person get activePerson => _activePerson;

  ValueListenable<Box<Datablock>> listenForDatablocks() {
    return Hive.box<Datablock>(_activePerson.databoxID).listenable();
  }

  void addDatablockToActivePerson(Datablock datablock) {
    Hive.box<Datablock>(_activePerson.databoxID).add(datablock);
  }
}
