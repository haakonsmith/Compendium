import 'package:flutter/material.dart' hide Table;
import 'package:moor/moor.dart';

abstract class DataBlock extends Table {
  Widget build(BuildContext context);
}

class LinkedTo {
  final Type to;

  const LinkedTo(this.to);
}
