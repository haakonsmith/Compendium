import 'package:moor/moor.dart';

// These imports are only needed to open the database
import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'dart:io';

// assuming that your file is called filename.dart. This will give an error at first,
// but it's needed for moor to know about the generated code
part 'model.g.dart';

// This will make moor generate a class called "Person" to represent a row in this table.
// By default, "People" would have been used because it only strips away the trailing "s"
// in the table name..
@DataClassName("Person")
class People extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firstName => text().withLength(min: 1, max: 32)();
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(
  tables: [People],
  // queries: {
  //   '_people': 'SELECT * FROM people'
  // }
)
class CompendiumDatabase extends _$CompendiumDatabase {
  // we tell the database where to store the data with this constructor
  CompendiumDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  @override
  int get schemaVersion => 1;

  Stream<List<Person>> get watchAllPeople => select(people).watch();

  Future<int> addPerson(PeopleCompanion person) {
    return into(people).insert(person);
  }
}
