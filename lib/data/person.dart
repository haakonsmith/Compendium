import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId: 1)
class Person {
  @HiveField(0)
  String firstName;

  @HiveField(1)
  String lastName;

  // @HiveField(2) // can we just use a map?
  // List<Datablocks> datablocks;

  @HiveField(2) // I mean, data blocks might be easier so we may switch to that in the future.
  Map<String, String> datablocks;

  Person({@required this.firstName, @required this.lastName});
}

class Datablocks {} // do we need this?
