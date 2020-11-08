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
  String databoxID;

  Person({
    @required this.firstName,
    @required this.lastName,
    @required this.databoxID,
  });

  static Person blank() {
    return Person(firstName: "", lastName: "", databoxID: "");
  }

  @override
  String toString() {
    return "$firstName $lastName";
  }
}
