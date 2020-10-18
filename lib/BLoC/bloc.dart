import 'package:compendium/data/model.dart';

abstract class Bloc {}

abstract class DatabaseBloc {
  CompendiumDatabase database;
  DatabaseBloc(CompendiumDatabase db) : database = db;
}
