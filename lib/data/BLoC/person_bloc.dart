import 'package:compendium/data/datablock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../person.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

/// This is just a neat dataclass to wrap all the attributes in
class ActiveData {
  // active data list, this abstracts away the whole root box or simply a datablock children list
  Datablock datablock;

  // This is important... But I forgot why
  // I think it's the rootNode index
  int rootNodeIndex = 0;

  // If it's a root node we don't need to do the nesting stuff
  // see references
  bool isRoot = true;

  // Track the active rootnode
  Datablock rootNode;
}

// It's a change notifier because while it's loading data
class PersonBloc extends ChangeNotifier {
  // This is the active person, basically the person that will be shown on the person screen
  Person _activePerson;

  Box<Datablock> _activePersonBox;
  ActiveData _activeData = ActiveData();

  // This is path from the rootNode to the current _activeData.data
  List<int> _path = List<int>();

  // This will be true if it's changing from _activePerson = null or _activePerson = a different person
  bool _updating = true;

  // Create the box or open it
  Future<void> setActivePerson(Person person, {Color color}) async {
    _updating = true;
    if (_activePerson != null && Hive.isBoxOpen(_activePerson.databoxID)) {
      if (_activePerson.databoxID.isNotEmpty) {
        await Hive.box<Datablock>(_activePerson.databoxID).close();
      }
    }

    _activePerson = person;
    _activePersonBox = await Hive.openBox<Datablock>(_activePerson.databoxID);

    _updating = false;

    print("FROM set active person" + color.toString());

    _activeData.isRoot = true;
    _activeData.datablock = Datablock(
        person.firstName + " " + person.lastName, "",
        colourValue: color.value, children: _activePersonBox.values.toList());
    notifyListeners();
  }

  Future<void> setActivePersonFromIndex(int personIndex, {Color color}) async {
    setActivePerson(Hive.box<Person>("people").getAt(personIndex),
        color: color);
  }

  bool get loading => _updating;

  Person get activePerson {
    if (_updating) return Person.blank();

    return _activePerson;
  }

  Future<List<Datablock>> listenToDatablockBox() async {
    while (_updating) {}

    return activePersonBox.values.toList();
  }

  Datablock get activeDatablock {
    if (_updating) return null;

    return _activeData.datablock;
  }

  Box<Datablock> get activePersonBox {
    if (_updating) return null;

    return _activePersonBox;
  }

  Datablock getParentFromActive(List<int> path) {
    var rootData = _activePersonBox.getAt(_path.first);
    Datablock parent = rootData;

    for (var i = 0; i < path.length; i++) {
      parent = parent.children[path[i]];
    }

    return parent;
  }

  void addDatablockToActive(Datablock datablock) {
    if (_activeData.isRoot) {
      _activeData.datablock.children.add(datablock);
      _activePersonBox.add(datablock);
    } else {
      /// This is here because, it would break my heart to remove it. Imagine going down a massive rabbit hole...
      /// "Am I disabled?"
      // Start the node search at the root node
      // The reason something like this ->
      // Datablock rootNode = _activePersonBox.values.toList()[_path.first]
      // is not used, is because well... I think that it might break the reference,
      // but I'm not sure, for now this works
      // Datablock newNode = _activeDatalist.rootNode;

      // // parentNode
      // for (var i = 0; i < _path.length - 1; i++) {
      //   newNode = newNode.children[_path[i]];
      // }

      // Now you may be thinking that this is stupid, however, if we do not,
      // then Stack overflow gets mad.
      // This is possibly because the ownership of the reference to this object
      // is not transfered to the List<Datablock>, and hence, gets deleted
      // But your guess is as good as mine
      _activeData.datablock.children.add(datablock);
      // print(_activeData.rootNode.toString());
      // print(_activeData.rootNode.toJson());

      _activePersonBox.putAt(_activeData.rootNodeIndex, _activeData.rootNode);
    }
  }

  void nestFurther(int index) {
    _activeData.rootNodeIndex = index;

    if (_activeData.isRoot) {
      // If it is root? We need to change to current root...
      _activeData.rootNode = _activeData.datablock.children[index];
      // If we nest past root, it won't be root
      _activeData.isRoot = false;
    }

    _path.add(index);

    _activeData.datablock.colourValue =
        _activeData.datablock.children[index].colourValue;
    _activeData.datablock.name = _activeData.datablock.children[index].name;
    _activeData.datablock.value = _activeData.datablock.children[index].value;
    _activeData.datablock.children =
        _activeData.datablock.children[index].children;
  }

  void popNesting() {
    if (_path.length != 0) {
      var finalIndex = _path.removeLast();

      _activeData.datablock.children = _activePersonBox.values.toList();

      // Traverse the path to get the futhest most item
      _path.forEach((index) {
        _activeData.datablock.children =
            _activeData.datablock.children[index].children;
      });

      _activeData.isRoot = false;
      _activeData.rootNodeIndex = finalIndex;
    } else {
      _activeData.isRoot = true;
    }
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

  Datablock datablockOfRoute(List<String> uriSegments) {
    Datablock active = _activePersonBox.getAt(int.parse(uriSegments[1]));

    int i = 3;
    for (; i < uriSegments.length; i += 2) {
      active = active.children[int.parse(uriSegments[i])];
    }

    return active;
  }

  static PersonBloc of(BuildContext context, {listen: false}) {
    return Provider.of<PersonBloc>(context, listen: listen);
  }
}
