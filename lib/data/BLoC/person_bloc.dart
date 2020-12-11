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

class ActiveDataList {
  List<Datablock> datalist = List<Datablock>();
  int index = 0;
  bool isRoot = true;
}

// It's a change notifier because while it's loading data
class PersonBloc extends ChangeNotifier {
  // This is the active person, basically the person that will be shown on the person screen
  Person _activePerson;

  Box<Datablock> _activePersonBox;
<<<<<<< Updated upstream
  ActiveDataList _activeDatalist = ActiveDataList();

  List<int> _path = List<int>();
=======
  Datablock activeDatablock;
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
    // print(_activePerson);
    // print(_activePerson.databoxID);
=======

>>>>>>> Stashed changes
    _activePersonBox = await Hive.openBox<Datablock>(_activePerson.databoxID);
    _updating = false;
    _activeDatalist.isRoot = true;
    _activeDatalist.datalist = _activePersonBox.values.toList();
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

  Future<List<Datablock>> listenToDatablockBox() async {
    while (_updating) {}

    return activePersonBox.values.toList();
  }

  List<Datablock> get activeDatalist {
    if (_updating) return null;

    return _activeDatalist.datalist;
  }

  Box<Datablock> get activePersonBox {
    if (_updating) return null;

    return _activePersonBox;
  }

  void addDatablockToActive(Datablock datablock) {
    var getParent = () {
      
    }
    _activeDatalist.datalist.add(datablock);

    var currentList = _activeDatalist.datalist;

    if (_activeDatalist.isRoot) {
      _activePersonBox.add(datablock);
    } else {
      // The whole datablock needs to be rebuilt to put back into the database
      var rootData = _activePersonBox.getAt(_activeDatalist.index);

      // var finalIndex = _path.removeLast();

      logger.i(rootData.toJson());

      var newData = rootData;

      var newPath = _path;
      // newPath.removeLast();

      print(newPath);

      newPath.forEach((index) {
        // logger.i({"index:": index, "datalist:": _activeDatalist.datalist});
        newData.children = newData.children[index].children;
      });

      print(newData.toJson());
      print(rootData.toJson());

      // _activePersonBox.putAt(
      //   _activeDatalist.index,
      // );
    }
  }

  void nestFurther(int index) {
    _activeDatalist.index = index;
    _activeDatalist.isRoot = false;
    _path.add(index);

    _activeDatalist.datalist = _activeDatalist.datalist[index].children;

    // logger.i(["Added item to path:", _path]);
    print("Added item: " + _path.toString());
  }

  void popNesting() {
    if (_path.length != 0) {
      var finalIndex = _path.removeLast();
      print("Removed item: " + _path.toString());

      _activeDatalist.datalist = _activePersonBox.values.toList();

      _path.forEach((index) {
        // logger.i({"index:": index, "datalist:": _activeDatalist.datalist});
        _activeDatalist.datalist = _activeDatalist.datalist[index].children;
      });

      _activeDatalist.isRoot = false;
      _activeDatalist.index = finalIndex;
    } else {
      // _path.clear();
      _activeDatalist.isRoot = true;
    }

    // logger.i(_path);
    // _activeDatalist.datalist = _activeDatalist.datalist[index].children;
  }

  ValueListenable<Box<Datablock>> listenForDatablocks() {
    return _activePersonBox.listenable();
  }

  void addDatablockToActivePerson(Datablock datablock) {
    // if (findDatablockRegex.hasMatch(name)) {
    //   var uriSegments =
    //       Uri.parse(ModalRoute.of(context).settings.name).pathSegments;
    //   dynamic val = PersonBloc.of(context).activePersonBox;

    //   var i = 0;

    //   for (; i < uriSegments.length; i += 2) {
    //     val = PersonBloc.of(context)
    //         .activePersonBox
    //         .getAt(int.parse(uriSegments[i]));
    //   }

    //   return val.buildPreview(uriSegments[i]);
    // }

    // if (uriSegments.first ==)
    _activePersonBox.add(datablock);
  }

  void addDatablockToActiveDatablock(Datablock datablock) {
    activeDatablock.children.add(datablock);
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
