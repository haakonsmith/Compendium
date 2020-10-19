// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Person extends DataClass implements Insertable<Person> {
  final int id;
  final String firstName;
  final String surName;
  Person({@required this.id, @required this.firstName, @required this.surName});
  factory Person.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Person(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      firstName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}first_name']),
      surName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}sur_name']),
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
    if (!nullToAbsent || surName != null) {
      map['sur_name'] = Variable<String>(surName);
    }
    return map;
  }

  PeopleCompanion toCompanion(bool nullToAbsent) {
    return PeopleCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      firstName: firstName == null && nullToAbsent
          ? const Value.absent()
          : Value(firstName),
      surName: surName == null && nullToAbsent
          ? const Value.absent()
          : Value(surName),
    );
  }

  factory Person.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Person(
      id: serializer.fromJson<int>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      surName: serializer.fromJson<String>(json['surName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'firstName': serializer.toJson<String>(firstName),
      'surName': serializer.toJson<String>(surName),
    };
  }

  Person copyWith({int id, String firstName, String surName}) => Person(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        surName: surName ?? this.surName,
      );
  @override
  String toString() {
    return (StringBuffer('Person(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('surName: $surName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(firstName.hashCode, surName.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Person &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.surName == this.surName);
}

class PeopleCompanion extends UpdateCompanion<Person> {
  final Value<int> id;
  final Value<String> firstName;
  final Value<String> surName;
  const PeopleCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.surName = const Value.absent(),
  });
  PeopleCompanion.insert({
    this.id = const Value.absent(),
    @required String firstName,
    @required String surName,
  })  : firstName = Value(firstName),
        surName = Value(surName);
  static Insertable<Person> custom({
    Expression<int> id,
    Expression<String> firstName,
    Expression<String> surName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (surName != null) 'sur_name': surName,
    });
  }

  PeopleCompanion copyWith(
      {Value<int> id, Value<String> firstName, Value<String> surName}) {
    return PeopleCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      surName: surName ?? this.surName,
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
    if (surName.present) {
      map['sur_name'] = Variable<String>(surName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeopleCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('surName: $surName')
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

  final VerificationMeta _surNameMeta = const VerificationMeta('surName');
  GeneratedTextColumn _surName;
  @override
  GeneratedTextColumn get surName => _surName ??= _constructSurName();
  GeneratedTextColumn _constructSurName() {
    return GeneratedTextColumn('sur_name', $tableName, false,
        minTextLength: 1, maxTextLength: 32);
  }

  @override
  List<GeneratedColumn> get $columns => [id, firstName, surName];
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
    if (data.containsKey('sur_name')) {
      context.handle(_surNameMeta,
          surName.isAcceptableOrUnknown(data['sur_name'], _surNameMeta));
    } else if (isInserting) {
      context.missing(_surNameMeta);
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

class Profile extends DataClass implements Insertable<Profile> {
  final int id;
  final int personId;
  final String title;
  Profile({@required this.id, @required this.personId, @required this.title});
  factory Profile.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Profile(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      personId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}person_id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || personId != null) {
      map['person_id'] = Variable<int>(personId);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      personId: personId == null && nullToAbsent
          ? const Value.absent()
          : Value(personId),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<int>(json['id']),
      personId: serializer.fromJson<int>(json['personId']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personId': serializer.toJson<int>(personId),
      'title': serializer.toJson<String>(title),
    };
  }

  Profile copyWith({int id, int personId, String title}) => Profile(
        id: id ?? this.id,
        personId: personId ?? this.personId,
        title: title ?? this.title,
      );
  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(personId.hashCode, title.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.personId == this.personId &&
          other.title == this.title);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<int> personId;
  final Value<String> title;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.title = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    @required int personId,
    @required String title,
  })  : personId = Value(personId),
        title = Value(title);
  static Insertable<Profile> custom({
    Expression<int> id,
    Expression<int> personId,
    Expression<String> title,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personId != null) 'person_id': personId,
      if (title != null) 'title': title,
    });
  }

  ProfilesCompanion copyWith(
      {Value<int> id, Value<int> personId, Value<String> title}) {
    return ProfilesCompanion(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  final GeneratedDatabase _db;
  final String _alias;
  $ProfilesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _personIdMeta = const VerificationMeta('personId');
  GeneratedIntColumn _personId;
  @override
  GeneratedIntColumn get personId => _personId ??= _constructPersonId();
  GeneratedIntColumn _constructPersonId() {
    return GeneratedIntColumn(
      'person_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, personId, title];
  @override
  $ProfilesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'profiles';
  @override
  final String actualTableName = 'profiles';
  @override
  VerificationContext validateIntegrity(Insertable<Profile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id'], _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Profile.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(_db, alias);
  }
}

abstract class _$CompendiumDatabase extends GeneratedDatabase {
  _$CompendiumDatabase(QueryExecutor e)
      : super(SqlTypeSystem.defaultInstance, e);
  $PeopleTable _people;
  $PeopleTable get people => _people ??= $PeopleTable(this);
  $ProfilesTable _profiles;
  $ProfilesTable get profiles => _profiles ??= $ProfilesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [people, profiles];
}
