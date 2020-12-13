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
  /// active datablock
  Datablock datablock;

  // This is important... But I forgot why
  // I think it's the rootNode index
  int rootNodeIndex = 0;

  int indexInParentNode = 0;

  // If it's a root node we don't need to do the nesting stuff
  // see references
  bool isRoot = true;

  /// Track the active rootnode
  Datablock rootNode;

  /// Updates the active data with children.elementAt(index) data
  void traverseDown(int index) {
    datablock = datablock.children[index];
  }
}

// It's a change notifier because while it's loading data
class PersonBloc extends ChangeNotifier {
  // This is the active person, basically the person that will be shown on the person screen
  Person _activePerson;

  /// Because a person is not a datablock it doesn't store a color
  Color _activeColor;

  Box<Datablock> _activePersonBox;
  ActiveData _activeData = ActiveData();

  // This is path from the rootNode to the current _activeData.data
  List<int> _path = List<int>();

  // This will be true if it's changing from _activePerson = null or _activePerson = a different person
  bool _updating = true;

  /// Constructs a datablock from the databox
  Datablock get rootDatablock =>
      Datablock(_activePerson.firstName + " " + _activePerson.lastName, "",
          colourValue: _activeColor.value,
          children: _activePersonBox.values.toList());

  // Create the box or open it
  Future<void> setActivePerson(Person person, {Color color}) async {
    _updating = true;
    if (_activePerson != null && Hive.isBoxOpen(_activePerson.databoxID)) {
      if (_activePerson.databoxID.isNotEmpty) {
        await Hive.box<Datablock>(_activePerson.databoxID).close();
      }
    }

    _activePerson = person;
    _activeColor = color;
    _activePersonBox = await Hive.openBox<Datablock>(_activePerson.databoxID);

    _activeData.isRoot = true;
    _activeData.datablock = rootDatablock;

    _updating = false;
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
    _activeData.datablock.children.add(datablock);

    if (_activeData.isRoot) {
      _activePersonBox.add(datablock);
    } else {
      _activePersonBox.putAt(_activeData.rootNodeIndex, _activeData.rootNode);
    }
  }

  void nestFurther(int index) {
    _activeData.indexInParentNode = index;

    if (_activeData.isRoot) {
      _activeData.rootNodeIndex = index;
      // If it is root? We need to change to current root...
      _activeData.rootNode = _activeData.datablock.children[index];
      logger.i("setting rootNode");
      // If we nest past root, it won't be root
      _activeData.isRoot = false;
    }

    _path.add(index);

    _activeData.traverseDown(index);
  }

  void popNesting() {
    if (_path.length != 0) {
      var finalIndex = _path.removeLast();

      _activeData.datablock = rootDatablock;

      // Traverse the path to get the futhest most item
      _path.forEach((index) {
        _activeData.traverseDown(index);
      });

      _activeData.isRoot = false;
      _activeData.indexInParentNode = finalIndex;
    } else {
      _activeData.isRoot = true;
    }
  }

  ValueListenable<Box<Datablock>> listenForDatablocks() {
    return _activePersonBox.listenable();
  }

  void removeDatablockFromActive(Datablock datablock, int index) {
    // _activeData.datablock.children.remove(datablock);
    // Probably more performant than the above
    _activeData.datablock.children.removeAt(index);

    if (_activeData.isRoot) {
      _activePersonBox.deleteAt(index);
    } else {
      _activePersonBox.putAt(_activeData.rootNodeIndex, _activeData.rootNode);
    }
  }

  void updateDatablockFromActive(Datablock datablock, int index) {
    _activeData.datablock.children[index] = datablock;

    if (_activeData.isRoot) {
      _activePersonBox.putAt(index, datablock);
    } else {
      _activePersonBox.putAt(_activeData.rootNodeIndex, _activeData.rootNode);
    }
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
