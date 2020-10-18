import 'package:compendium/data/profiles/data_block.dart';
import 'package:moor/moor.dart';

import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

// import profiles
import 'package:compendium/data/profiles/academic_profile.dart';

// assuming that your file is called model.dart. This will give an error at first,
// but it's needed for moor to know about the generated code
part 'model.g.dart';

// This will make moor generate a class called "Person" to represent a row in this table.
// By default, "People" would have been used because it only strips away the trailing "s"
// in the table name..
@DataClassName("Person")
class People extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firstName => text().withLength(min: 1, max: 32)();
  TextColumn get surName => text().withLength(min: 1, max: 32)();
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    // const bool inDevelopment = true;
    // if (inDevelopment) {
    //   await file.delete();
    // }
    return VmDatabase(file);
  });
}

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(
  tables: [People, AcademicProfiles, Assessments],
)
class CompendiumDatabase extends _$CompendiumDatabase {
  // we tell the database where to store the data with this constructor
  CompendiumDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  @override
  int get schemaVersion => 1;

  Stream<List<Person>> get watchAllPeople => select(people).watch();
  Stream<List<DataBlock>> watchPersonDataBlocks(int personID) {
    var query =
        select(academicProfiles).where((tbl) => tbl.personID.equals(personID));

    List<SimpleSelectStatement> queries = List();

    allTables.forEach((table) {
      queries.add((select(academicProfiles)..where((tbl) => tbl.)));
    });
  }

  Future<int> addPerson(PeopleCompanion person) {
    return into(people).insert(person);
  }
}
