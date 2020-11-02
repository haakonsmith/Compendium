import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

part 'datablock.g.dart';

@HiveType(typeId: 2)
class Datablock {
  @HiveField(0)
  String name;

  @HiveField(1)
  Color colour;

  @HiveField(2)
  Map<String, String> attributes;

  Datablock({
    @required this.name,
    @required this.colour,
    @required this.attributes,
  });
}
