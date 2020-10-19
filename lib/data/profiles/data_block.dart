import 'package:flutter/material.dart' hide Table;
import 'package:moor/moor.dart';

import '../model.dart';

class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get personId => integer()();
  TextColumn get title => text()();
}

abstract class Datablock extends Profile {
  Widget build(BuildContext context);
}

class LinkedTo {
  final Type to;

  const LinkedTo(this.to);
}

class MedicalTemplate extends Datablock {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
