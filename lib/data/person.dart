import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId: 1)
class Person {
  @HiveField(0)
  String firstName;

  @HiveField(1)
  String lastName;

  /// This Field is the datablock index as a string. That is the difference between index and id
  /// This works as an id because the index always changes, but that is fine because the change updates everything...
  /// Plus the index is always unique within the box
  @HiveField(2)
  String databoxID;

  Person({
    @required this.firstName,
    @required this.lastName,
    @required this.databoxID,
  });

  factory Person.blank() {
    return Person(firstName: "", lastName: "", databoxID: "");
  }

  @override
  String toString() {
    return "$firstName $lastName";
  }

  Map toJson() => {'firstName': firstName, 'lastName': lastName, 'databoxID': databoxID};
}
