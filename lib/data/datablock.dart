import 'dart:convert';
import 'dart:ui';

import 'package:compendium/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

part 'datablock.g.dart';

@HiveType(typeId: 2)
class Datablock {
  static const int defaultColorValue = CompendiumThemeData.blueBlackPrimaryValue;

  @HiveField(0)
  String name;

  /// Hive can't store [Color], so just store an int and convert.
  @HiveField(1)
  int colorValue;

  Color get color => Color(colorValue);
  set color(Color color) => colorValue = color.value;

  @HiveField(2)
  List<Datablock> children = <Datablock>[];

  @HiveField(3)
  String value;

  /// This stores all the metadata about the datablock for things like formatting, etc.
  bool get isCategory {
    print(metadata.toJson());
    print(metadata.isCategory);
    return metadata.isCategory;
  }

  @HiveField(4)
  DatablockMetadata metadata;

  Datablock(this.name, this.value, {this.colorValue = defaultColorValue, List<Datablock> children, DatablockMetadata metadata})
      // https://stackoverflow.com/questions/54279223/flutter-default-assignment-of-list-parameter-in-a-constructor
      // Otherwise null errors appear
      : children = children ?? [],
        metadata = metadata ?? DatablockMetadata.blank();

  String toString() => "name: " + name + " colorValue: " + Color(colorValue).toString() + " value: " + value + " children?: " + (children == null).toString();

  Map toJson() => {"name": name, "value": value, "colorValue": colorValue, "children": children.map((c) => c.toJson()).toList(), "metadata": metadata.toJson()};

  /// Constructs a datablock from json, recursively
  ///
  /// The [json] parameter expects something in the form of:
  /// ```
  ///  {
  ///    'name': String,
  ///    'value': String,
  ///    'colorValue': int,
  ///    'color': Color,
  ///    'children': List<Datablock>,
  ///    'metadata': Map<String, dynamic>
  /// }
  /// ```
  ///
  /// Note:
  ///
  ///* The parameter color will be stored as `color.value`
  ///* This will accept color or colorValue, if both are given then color is preffered
  Datablock.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? "",
        value = json['value'] ?? "" {
    if (json.containsKey('color'))
      color = json[color];
    else
      colorValue = json[colorValue] ?? defaultColorValue;

    children = [];
    (json['children'] ?? []).forEach((list) {
      //Creates an instance of PlaceName and adds to the placeNames list.
      children.add(Datablock.fromJson(list));
    });

    metadata = DatablockMetadata.fromJson(json['metadata']);
    print("MetadataJSON-> " + metadata.toJson().toString());
  }

  /// Performs a deep copy of the object
  Datablock copy() {
    var newDatablock = Datablock(name, value, colorValue: colorValue, metadata: metadata);
    newDatablock.children = children.map((c) => c.copy()).toList();
    return newDatablock;
  }

  Datablock.blank()
      : name = "",
        value = "",
        colorValue = defaultColorValue,
        children = <Datablock>[],
        metadata = DatablockMetadata.blank();
}

@HiveType(typeId: 3)
enum DatablockDisplayStyle {
  @HiveField(0)
  stacked,

  @HiveField(1)
  flat,
}

@HiveType(typeId: 5)
enum DatablockValueStyle {
  @HiveField(0)
  value,

  @HiveField(1)
  bar,

  @HiveField(2)
  textarea,
}

@HiveType(typeId: 4)
class DatablockMetadata {
  @HiveField(0)
  DatablockDisplayStyle displayStyle;
  @HiveField(1)
  bool isCategory;
  @HiveField(2)
  DateTime timeCreated;
  @HiveField(3)
  DatablockValueStyle valueStyle;
  @HiveField(4)
  Datablock suggestedChild;

  static DatablockDisplayStyle datablockDisplayStyleFromString(String string) {
    print(string);
    return DatablockDisplayStyle.values.firstWhere((e) => e.toString().replaceFirst("DatablockDisplayStyle.", "") == string);
  }

  static DatablockValueStyle datablockValueStyleFromString(String string) => DatablockValueStyle.values.firstWhere((e) => e.toString().replaceFirst("DatablockValueStyle.", "") == string);

  DatablockMetadata(this.isCategory, {this.suggestedChild, this.valueStyle, this.displayStyle = DatablockDisplayStyle.flat, timeCreated}) : this.timeCreated = timeCreated ?? DateTime.now();

  /// This function interprets metadata json.
  /// For naming, generally, the json will be a snakecase version of the class member.
  DatablockMetadata.fromJson(Map<String, dynamic> json)
      : isCategory = json.containsKey('category') ? json['category'] : false,
        timeCreated = json.containsKey('time_created') ? json['time_created'] : DateTime.now(),
        suggestedChild = json.containsKey('suggested_child') ? Datablock.fromJson(json['suggested_child']) : null,
        displayStyle = json.containsKey('display_style') ? datablockDisplayStyleFromString(json['display_style']) : DatablockDisplayStyle.flat,
        valueStyle = json.containsKey('value_style') ? datablockValueStyleFromString(json['value_style']) : DatablockValueStyle.value;

  // https://stackoverflow.com/questions/20015249/in-dart-can-you-call-another-constructor-from-a-constructor#20016695
  // It's done this way to make the final fields happy
  /// This constructor just uses the default statements on the json constructor
  factory DatablockMetadata.blank() {
    var result = DatablockMetadata.fromJson({});
    return result;
  }

  Map toJson() => {"isCategory": isCategory, "display_style": displayStyle.toString()};
}
