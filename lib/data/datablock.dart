import 'dart:ui';

import 'package:compendium/data/theme.dart';
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

  Widget buildPreview(BuildContext context) {
    // TODO fix, This is the MOST DISASTROUSLY ugly thing ever, and I'm fully aware, but also. Goodnight.
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      shadowColor: CompendiumColors.primaryBlueBlack,
      elevation: 15,
      child: ClipPath(
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          child: InkWell(
            onTap: () {
              print("test");
            },
            child: Container(
                // height: 180,
                decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(color: Color(colourValue), width: 15)),
                  // color: Colors.white,
                ),
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      )
                    ],
                  ),
                )),
          )),
    );
  }
}
