import 'package:compendium/data/datablock.dart';
import 'package:compendium/data/json_data_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../person.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

class DatablockTree {
  /// active datablock
  Datablock datablockContext;

  Datablock _rootData;

  bool _isEmpty = true;

  DatablockTree(this._rootData)
      : this._isEmpty = false,
        datablockContext = _rootData;

  DatablockTree.empty();

  // If it's a root node we don't need to do the nesting stuff
  // see references
  bool _isRoot = true;
  bool get isRoot => _isRoot;

  // This is path from the rootNode to the current _datablockTree.data
  List<int> path = [];

  /// Track the active rootnode
  Datablock rootNode;

  /// Updates the active data with children.elementAt(index) data
  void traverseDown(int index) {
    if (_isEmpty) throw StateError('Datablock Tree does not contain data');

    if (_isRoot) {
      // _datablockTree.rootNodeIndex = index;
      // If it is root? We need to change to current root...
      rootNode = datablockContext.children[index];

      // If we nest past root, it won't be root
      _isRoot = false;
    }

    path.add(index);

    // Finally update context
    // This is here because otherwise there is an fixed list error
    var children = List<Datablock>.from(datablockContext.children[index].children);

    datablockContext = datablockContext.children[index];
    datablockContext.children = children;

    print(datablockContext);
  }

  bool hasFixLength(List list) {
    try {
      list
        ..add(null)
        ..removeLast();
      return false;
    } on UnsupportedError {
      return true;
    }
  }

  /// update the context to be the parent datablock.
  void traverseUp() {
    if (_isEmpty) throw StateError('Datablock Tree does not contain data');

    if (path.isNotEmpty) {
      path.removeLast();

      datablockContext = _rootData;
      _isRoot = true;

      // Traverse the path to get the futhest most item
      path.forEach((index) {
        traverseDown(index);
      });
    }

    _isRoot = (path.length <= 1);
  }
}

/// It's a change notifier because while it's loading data
/// This tracks the active person, and the active datablock
class PersonBloc extends ChangeNotifier {
  /// This is the active/tracked person
  Person _activePerson;

  /// Because a person is not a datablock it doesn't store a color
  Color _activeColor;

  Box<Person> _personBox;

  Box<Person> get personBox => Hive.isBoxOpen('people') ? _personBox : loadPersonBox();
  Box<Datablock> _activePersonBox;
  DatablockTree _datablockTree = DatablockTree.empty();

  // This will be true if it's changing from _activePerson = null or _activePerson = a different person
  bool _updating = true;

  /// Constructs a datablock from the databox
  Datablock get rootDatablock => Datablock(_activePerson.firstName + " " + _activePerson.lastName, "", colorValue: _activeColor.value, children: _activePersonBox.values.toList());

  PersonBloc() {
    loadPersonBox();
  }

  Future<void> loadPersonBox() async {
    _personBox = await Hive.openBox<Person>('people');
    _updating = false;

    notifyListeners();
  }

  // Create the box or open it
  Future<void> setActivePerson(Person person, {Color color}) async {
    _updating = true;
    if (_activePerson != null && Hive.isBoxOpen(_activePerson.databoxID)) {
      if (_activePerson.databoxID.isNotEmpty) {
        await Hive.box<Datablock>(_activePerson.databoxID).close();
      }
    }

    print(await getApplicationSupportDirectory());
    print(await JsonDataInterface.jsonifyDatabase());

    _activePerson = person;
    _activeColor = color;
    _activePersonBox = await Hive.openBox<Datablock>(_activePerson.databoxID);

    _datablockTree = DatablockTree(rootDatablock);

    _updating = false;
    notifyListeners();
  }

  /// Quality of life improvement over setActivePerson
  Future<void> setActivePersonFromIndex(int personIndex, {Color color}) async {
    setActivePerson(Hive.box<Person>("people").getAt(personIndex), color: color);
  }

  set loading(bool v) => _updating = v;
  bool get loading => _updating;

  Person get activePerson {
    if (_updating) return Person.blank();

    return _activePerson;
  }

  Datablock get activeDatablock {
    if (_updating) return null;

    return _datablockTree.datablockContext;
  }

  Box<Datablock> get activePersonBox {
    if (_updating) return null;

    return _activePersonBox;
  }

  ValueListenable<Box<Datablock>> listenToDatablocks() => _activePersonBox.listenable();

  void addDatablockToActive(Datablock datablock) {
    _datablockTree.datablockContext.children.add(datablock);

    if (_datablockTree.isRoot) {
      _activePersonBox.add(datablock);
    } else {
      _activePersonBox.putAt(_datablockTree.path.first, _datablockTree.rootNode);
    }

    notifyListeners();
  }

  /// Remove a datablock from the currently activeDatablock based on index
  void removeDatablockFromActive(int index) {
    _datablockTree.datablockContext.children.removeAt(index);

    if (_datablockTree.isRoot) {
      _activePersonBox.deleteAt(index);
    } else {
      _activePersonBox.putAt(_datablockTree.path.first, _datablockTree.rootNode);
    }

    notifyListeners();
  }

  void updateDatablockFromActive(Datablock datablock, int index) {
    _datablockTree.datablockContext.children[index] = datablock;

    if (_datablockTree.isRoot) {
      _activePersonBox.putAt(index, datablock);
    } else {
      _activePersonBox.putAt(_datablockTree.path.first, _datablockTree.rootNode);
    }

    // notifyListeners();
  }

  void nestFurther(int index) {
    _datablockTree.traverseDown(index);
    notifyListeners();
  }

  void popNesting() {
    _datablockTree.traverseUp();
    notifyListeners();
  }

  // ////////////////////////////////////////////////
  // ////////////////////// Person related code ////
  // //////////////////////////////////////////////

  /// Add a person to the Person box
  /// Equvilant: `Hive.box<Person>("people").add(person)`
  void addPerson(Person person) => Hive.box<Person>("people").add(person);

  void deletePersonAtIndex(int index) {
    Hive.box<Person>("people").deleteAt(index);
    Hive.deleteBoxFromDisk(_activePerson.databoxID);
  }

  static PersonBloc of(BuildContext context, {listen: false}) {
    return Provider.of<PersonBloc>(context, listen: listen);
  }
}
