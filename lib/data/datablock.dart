import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

part 'datablock.g.dart';

// each datablock will have it's own box with a title of datablockID
@HiveType(typeId: 2)
class Datablock {
  @HiveField(0)
  String name;

  // Hive can't store [Color], so just store an int and convert.
  @HiveField(1)
  int colourValue;

  @HiveField(2)
  Map<String, String> attributes;

  Datablock({
    @required this.name,
    @required this.colourValue,
  });

  Widget build(BuildContext context) {
    // TODO fix, This is the MOST DISASTROUSLY ugly thing ever, and I'm fully aware, but also. Goodnight.
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Column(children: [
              SizedBox(
                  width: double.infinity,
                  height: 20.0,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(20.0),
                    color: Colors.indigoAccent,
                  ))),
              Text(name),
            ])));
  }
}
