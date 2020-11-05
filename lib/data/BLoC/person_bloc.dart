import 'package:compendium/data/datablock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../person.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PersonBloc {
  // This is the active person, basically the person that will be shown on the person screen
  Person activePerson;

  PersonBloc();

  // Create the box or open it
  Future<void> setActivePerson(Person person) async {
    activePerson = person;
    await Hive.openBox<Datablock>(activePerson.databoxID);
  }

  Future<void> setActivePersonFromIndex(int personIndex) async {
    setActivePerson(Hive.box<Person>("people").getAt(personIndex));
  }

  Person get getActivePerson => activePerson;

  ValueListenable<Box<Datablock>> listenForDatablocks() {
    return Hive.box<Datablock>(activePerson.databoxID).listenable();
  }

  void addDatablockToActivePerson(Datablock datablock) {
    Hive.box<Datablock>(activePerson.databoxID).add(datablock);
  }
}
