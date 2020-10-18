import 'package:flutter/material.dart';
import 'package:moor/moor.dart';

import '../model.dart';
import 'data_block.dart';

@LinkedTo(Person)
class AcademicProfiles extends DataBlock {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get personID => integer()();

  @override
  Widget build(BuildContext context) {
    return Text("test");
  }
}

@LinkedTo(AcademicProfiles)
class Assessments extends DataBlock {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get academicProfileID => integer()();
  TextColumn get grade => text().withLength(min: 1, max: 2)();
  TextColumn get title => text().withLength(min: 1)();
  DateTimeColumn get submissionDate => dateTime()();
  DateTimeColumn get givenDate => dateTime()();

  @override
  Widget build(BuildContext context) {
    return Text("test");
  }
}
