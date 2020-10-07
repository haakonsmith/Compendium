// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Person extends DataClass implements Insertable<Person> {
  final int id;
  final String firstName;
  Person({@required this.id, @required this.firstName});
  factory Person.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Person(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      firstName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}first_name']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || firstName != null) {
      map['first_name'] = Variable<String>(firstName);
    }
    return map;
  }

  PeopleCompanion toCompanion(bool nullToAbsent) {
    return PeopleCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      firstName: firstName == null && nullToAbsent
          ? const Value.absent()
          : Value(firstName),
    );
  }

  factory Person.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Person(
      id: serializer.fromJson<int>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'firstName': serializer.toJson<String>(firstName),
    };
  }

  Person copyWith({int id, String firstName}) => Person(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
      );
  @override
  String toString() {
    return (StringBuffer('Person(')
          ..write('id: $id, ')
          ..write('firstName: $firstName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, firstName.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Person &&
          other.id == this.id &&
          other.firstName == this.firstName);
}

class PeopleCompanion extends UpdateCompanion<Person> {
  final Value<int> id;
  final Value<String> firstName;
  const PeopleCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
  });
  PeopleCompanion.insert({
    this.id = const Value.absent(),
    @required String firstName,
  }) : firstName = Value(firstName);
  static Insertable<Person> custom({
    Expression<int> id,
    Expression<String> firstName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
    });
  }

  PeopleCompanion copyWith({Value<int> id, Value<String> firstName}) {
    return PeopleCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeopleCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName')
          ..write(')'))
        .toString();
  }
}

class $PeopleTable extends People with TableInfo<$PeopleTable, Person> {
  final GeneratedDatabase _db;
  final String _alias;
  $PeopleTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _firstNameMeta = const VerificationMeta('firstName');
  GeneratedTextColumn _firstName;
  @override
  GeneratedTextColumn get firstName => _firstName ??= _constructFirstName();
  GeneratedTextColumn _constructFirstName() {
    return GeneratedTextColumn('first_name', $tableName, false,
        minTextLength: 1, maxTextLength: 32);
  }

  @override
  List<GeneratedColumn> get $columns => [id, firstName];
  @override
  $PeopleTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'people';
  @override
  final String actualTableName = 'people';
  @override
  VerificationContext validateIntegrity(Insertable<Person> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name'], _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Person map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Person.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $PeopleTable createAlias(String alias) {
    return $PeopleTable(_db, alias);
  }
}

abstract class _$CompendiumDatabase extends GeneratedDatabase {
  _$CompendiumDatabase(QueryExecutor e)
      : super(SqlTypeSystem.defaultInstance, e);
  $PeopleTable _people;
  $PeopleTable get people => _people ??= $PeopleTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [people];
}
