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
  @HiveField(4)
  Map<String, dynamic> metadata = {};

  bool get isCatagory => (metadata['category'] ?? "false") == "true";
  set isCatagory(bool val) => metadata['category'] = val.toString();

  Datablock(this.name, this.value, {this.colorValue = defaultColorValue, List<Datablock> children, Map<String, dynamic> metadata})
      // https://stackoverflow.com/questions/54279223/flutter-default-assignment-of-list-parameter-in-a-constructor
      // Otherwise null errors appear
      : children = children ?? [],
        metadata = metadata ?? Map<String, dynamic>();

  String toString() => "name: " + name + " colorValue: " + Color(colorValue).toString() + " value: " + value + " children?: " + (children == null).toString();

  Map toJson() => {"name": name, "value": value, "colorValue": colorValue, "children": children.map((c) => c.toJson()).toList(), "metadata": metadata};

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
  ///    'metadata': Map<String, String>
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
    metadata = json['metadata'];
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
        metadata = {};

  /// LOL completely broken. Needs to be revisited
  /// TODO fix
  Widget buildPreview(BuildContext context, int datablockIndex) {
    // TODO fix, This is the MOST DISASTROUSLY ugly thing ever, and I'm fully aware, but also. Goodnight.
    return Card(
      elevation: 15,
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => Navigator.of(context).pushNamed("/datablock/$datablockIndex"),
          child: Container(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Color(colorValue), width: 15)),
            ),
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                          title: Text('Are you sure?'),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RaisedButton(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true).pop('dialog');
                                },
                              ),
                              RaisedButton(
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  // PersonBloc.of(context)
                                  //     .deleteDatablockAtIndex(datablockIndex);
                                  Navigator.of(context, rootNavigator: true).pop('dialog');
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
