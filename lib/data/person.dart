import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId: 1)
class Person {
  @HiveField(0)
  String firstName;

  @HiveField(1)
  String lastName;

  @HiveField(2)
  String datablockID;

  Person({
    @required this.firstName,
    @required this.lastName,
    @required this.datablockID,
  });
}
