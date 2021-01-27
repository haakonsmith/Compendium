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
      data['data'] = boxData.map((e) => e.toJson());
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
    data['people'] = peopleData.map((e) => e.toJson());

    for (var person in peopleData) {
      Box box = await Hive.openBox<Datablock>(person.databoxID);
      data[person.databoxID] = await _jsonifyHiveBox(box);
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

  static void exportDatabase() async {
    await writeJsonData();
  }
}
