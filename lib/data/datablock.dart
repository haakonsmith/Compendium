import 'dart:ui';

import 'package:compendium/data/BLoC/person_bloc.dart';
import 'package:compendium/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

part 'datablock.g.dart';

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
          onTap: () =>
              Navigator.of(context).pushNamed("/datablock/$datablockIndex"),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(color: Color(colourValue), width: 15)),
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
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
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog');
                                },
                              ),
                              RaisedButton(
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  PersonBloc.of(context)
                                      .deleteDatablockAtIndex(datablockIndex);
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog');
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
