import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'datablock.dart';
import 'hive_boxes.dart';
import 'person.dart';

class JsonDataInterface {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/json_compendium_data.json');
  }

  /// This jsonifies all the datablocks in a box
  static Future<Map<String, dynamic>> _jsonifyHiveBox<T>(Box<T> box) {
    Map<String, dynamic> data = Map();

    final boxData = box.values.cast<Datablock>();

    try {
      data['"data"'] = boxData.map((e) => json.encode(e)).toList();
    } catch (e) {
      return Future.error(e);
    }

    return Future.value(data);
  }

  static Future<Map<String, dynamic>> jsonifyDatabase() async {
    // The data that will be eventually returned
    Map<String, dynamic> data = Map();

    Box<Person> personBox = await Hive.openBox<Person>(HiveBoxes.personBox);

    // Here we copy the data to a different variable so that any changes to the database won't effect this
    final peopleData = personBox.values;

    // Create and populate the people part of the json
    data['"people"'] = peopleData.map((e) => json.encode(e)).toList();

    for (var person in peopleData) {
      Box box = await Hive.openBox<Datablock>(person.databoxID);
      final id = person.databoxID;
      data['"$id"'] = await _jsonifyHiveBox(box);
    }

    print(data.runtimeType);

    return Future.value(data);
  }

  static Future<void> writeJsonData() async {
    final raw = await jsonifyDatabase();
    print(raw.runtimeType);
    print(raw);

    Uint8List data = Uint8List.fromList((await jsonifyDatabase()).toString().codeUnits);

    if (Platform.isMacOS) {
      final picker = FilePickerCross(data, path: "test", type: FileTypeCross.any);
      picker.exportToStorage();
    } else {
      final file = await _localFile;
      file.writeAsBytes(data);
    }
  }

  static Future<void> exportDatabase() async {
    await writeJsonData();
  }

  /// This nukes the entire database and everything
  static Future<void> _clearDatabase() async {
    Box<Person> personBox = await Hive.openBox<Person>(HiveBoxes.personBox);

    for (final person in personBox.values) {
      Box box = await Hive.openBox<Datablock>(person.databoxID);

      await box.clear();
    }

    await personBox.clear();
  }

  /// This function creates a 'import back up' and nukes the in ram data base
  static Future<void> importDatabase() async {
    final rawData = await readJsonData();

    _clearDatabase();

    // Import personbox
    await Hive.close();
    Box<Person> personBox = await Hive.openBox<Person>(HiveBoxes.personBox);

    var people = (rawData['people'] as List).map((e) => Person.fromJson(e));
    personBox.addAll(people);

    print(personBox.values);

    for (final person in people) {
      Box box = await Hive.openBox<Datablock>(person.databoxID);

      final datablocks = (rawData[person.databoxID]['data'] as List).map((e) => Datablock.fromJson(e));

      box.addAll(datablocks);
    }
  }

  static Future<Map<String, dynamic>> readJsonData() async {
    String data;

    if (Platform.isMacOS) {
      final picker = await FilePickerCross.importFromStorage();
      data = picker.toString();
    } else {
      final file = await _localFile;
      data = await file.readAsString();
    }

    return Future.value(json.decode(data) as Map<String, dynamic>);
  }
}
