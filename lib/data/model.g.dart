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

class AcademicProfile extends DataClass implements Insertable<AcademicProfile> {
  final int id;
  final int personID;
  AcademicProfile({@required this.id, @required this.personID});
  factory AcademicProfile.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    return AcademicProfile(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      personID:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}person_i_d']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || personID != null) {
      map['person_i_d'] = Variable<int>(personID);
    }
    return map;
  }

  AcademicProfilesCompanion toCompanion(bool nullToAbsent) {
    return AcademicProfilesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      personID: personID == null && nullToAbsent
          ? const Value.absent()
          : Value(personID),
    );
  }

  factory AcademicProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return AcademicProfile(
      id: serializer.fromJson<int>(json['id']),
      personID: serializer.fromJson<int>(json['personID']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personID': serializer.toJson<int>(personID),
    };
  }

  AcademicProfile copyWith({int id, int personID}) => AcademicProfile(
        id: id ?? this.id,
        personID: personID ?? this.personID,
      );
  @override
  String toString() {
    return (StringBuffer('AcademicProfile(')
          ..write('id: $id, ')
          ..write('personID: $personID')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, personID.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is AcademicProfile &&
          other.id == this.id &&
          other.personID == this.personID);
}

class AcademicProfilesCompanion extends UpdateCompanion<AcademicProfile> {
  final Value<int> id;
  final Value<int> personID;
  const AcademicProfilesCompanion({
    this.id = const Value.absent(),
    this.personID = const Value.absent(),
  });
  AcademicProfilesCompanion.insert({
    this.id = const Value.absent(),
    @required int personID,
  }) : personID = Value(personID);
  static Insertable<AcademicProfile> custom({
    Expression<int> id,
    Expression<int> personID,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personID != null) 'person_i_d': personID,
    });
  }

  AcademicProfilesCompanion copyWith({Value<int> id, Value<int> personID}) {
    return AcademicProfilesCompanion(
      id: id ?? this.id,
      personID: personID ?? this.personID,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personID.present) {
      map['person_i_d'] = Variable<int>(personID.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AcademicProfilesCompanion(')
          ..write('id: $id, ')
          ..write('personID: $personID')
          ..write(')'))
        .toString();
  }
}

class $AcademicProfilesTable extends AcademicProfiles
    with TableInfo<$AcademicProfilesTable, AcademicProfile> {
  final GeneratedDatabase _db;
  final String _alias;
  $AcademicProfilesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _personIDMeta = const VerificationMeta('personID');
  GeneratedIntColumn _personID;
  @override
  GeneratedIntColumn get personID => _personID ??= _constructPersonID();
  GeneratedIntColumn _constructPersonID() {
    return GeneratedIntColumn(
      'person_i_d',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, personID];
  @override
  $AcademicProfilesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'academic_profiles';
  @override
  final String actualTableName = 'academic_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<AcademicProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('person_i_d')) {
      context.handle(_personIDMeta,
          personID.isAcceptableOrUnknown(data['person_i_d'], _personIDMeta));
    } else if (isInserting) {
      context.missing(_personIDMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AcademicProfile map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return AcademicProfile.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $AcademicProfilesTable createAlias(String alias) {
    return $AcademicProfilesTable(_db, alias);
  }
}

class Assessment extends DataClass implements Insertable<Assessment> {
  final int id;
  final int academicProfileID;
  final String grade;
  final String title;
  final DateTime submissionDate;
  final DateTime givenDate;
  Assessment(
      {@required this.id,
      @required this.academicProfileID,
      @required this.grade,
      @required this.title,
      @required this.submissionDate,
      @required this.givenDate});
  factory Assessment.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Assessment(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      academicProfileID: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}academic_profile_i_d']),
      grade:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}grade']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      submissionDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}submission_date']),
      givenDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}given_date']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || academicProfileID != null) {
      map['academic_profile_i_d'] = Variable<int>(academicProfileID);
    }
    if (!nullToAbsent || grade != null) {
      map['grade'] = Variable<String>(grade);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || submissionDate != null) {
      map['submission_date'] = Variable<DateTime>(submissionDate);
    }
    if (!nullToAbsent || givenDate != null) {
      map['given_date'] = Variable<DateTime>(givenDate);
    }
    return map;
  }

  AssessmentsCompanion toCompanion(bool nullToAbsent) {
    return AssessmentsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      academicProfileID: academicProfileID == null && nullToAbsent
          ? const Value.absent()
          : Value(academicProfileID),
      grade:
          grade == null && nullToAbsent ? const Value.absent() : Value(grade),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      submissionDate: submissionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(submissionDate),
      givenDate: givenDate == null && nullToAbsent
          ? const Value.absent()
          : Value(givenDate),
    );
  }

  factory Assessment.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Assessment(
      id: serializer.fromJson<int>(json['id']),
      academicProfileID: serializer.fromJson<int>(json['academicProfileID']),
      grade: serializer.fromJson<String>(json['grade']),
      title: serializer.fromJson<String>(json['title']),
      submissionDate: serializer.fromJson<DateTime>(json['submissionDate']),
      givenDate: serializer.fromJson<DateTime>(json['givenDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'academicProfileID': serializer.toJson<int>(academicProfileID),
      'grade': serializer.toJson<String>(grade),
      'title': serializer.toJson<String>(title),
      'submissionDate': serializer.toJson<DateTime>(submissionDate),
      'givenDate': serializer.toJson<DateTime>(givenDate),
    };
  }

  Assessment copyWith(
          {int id,
          int academicProfileID,
          String grade,
          String title,
          DateTime submissionDate,
          DateTime givenDate}) =>
      Assessment(
        id: id ?? this.id,
        academicProfileID: academicProfileID ?? this.academicProfileID,
        grade: grade ?? this.grade,
        title: title ?? this.title,
        submissionDate: submissionDate ?? this.submissionDate,
        givenDate: givenDate ?? this.givenDate,
      );
  @override
  String toString() {
    return (StringBuffer('Assessment(')
          ..write('id: $id, ')
          ..write('academicProfileID: $academicProfileID, ')
          ..write('grade: $grade, ')
          ..write('title: $title, ')
          ..write('submissionDate: $submissionDate, ')
          ..write('givenDate: $givenDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          academicProfileID.hashCode,
          $mrjc(
              grade.hashCode,
              $mrjc(title.hashCode,
                  $mrjc(submissionDate.hashCode, givenDate.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Assessment &&
          other.id == this.id &&
          other.academicProfileID == this.academicProfileID &&
          other.grade == this.grade &&
          other.title == this.title &&
          other.submissionDate == this.submissionDate &&
          other.givenDate == this.givenDate);
}

class AssessmentsCompanion extends UpdateCompanion<Assessment> {
  final Value<int> id;
  final Value<int> academicProfileID;
  final Value<String> grade;
  final Value<String> title;
  final Value<DateTime> submissionDate;
  final Value<DateTime> givenDate;
  const AssessmentsCompanion({
    this.id = const Value.absent(),
    this.academicProfileID = const Value.absent(),
    this.grade = const Value.absent(),
    this.title = const Value.absent(),
    this.submissionDate = const Value.absent(),
    this.givenDate = const Value.absent(),
  });
  AssessmentsCompanion.insert({
    this.id = const Value.absent(),
    @required int academicProfileID,
    @required String grade,
    @required String title,
    @required DateTime submissionDate,
    @required DateTime givenDate,
  })  : academicProfileID = Value(academicProfileID),
        grade = Value(grade),
        title = Value(title),
        submissionDate = Value(submissionDate),
        givenDate = Value(givenDate);
  static Insertable<Assessment> custom({
    Expression<int> id,
    Expression<int> academicProfileID,
    Expression<String> grade,
    Expression<String> title,
    Expression<DateTime> submissionDate,
    Expression<DateTime> givenDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (academicProfileID != null) 'academic_profile_i_d': academicProfileID,
      if (grade != null) 'grade': grade,
      if (title != null) 'title': title,
      if (submissionDate != null) 'submission_date': submissionDate,
      if (givenDate != null) 'given_date': givenDate,
    });
  }

  AssessmentsCompanion copyWith(
      {Value<int> id,
      Value<int> academicProfileID,
      Value<String> grade,
      Value<String> title,
      Value<DateTime> submissionDate,
      Value<DateTime> givenDate}) {
    return AssessmentsCompanion(
      id: id ?? this.id,
      academicProfileID: academicProfileID ?? this.academicProfileID,
      grade: grade ?? this.grade,
      title: title ?? this.title,
      submissionDate: submissionDate ?? this.submissionDate,
      givenDate: givenDate ?? this.givenDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (academicProfileID.present) {
      map['academic_profile_i_d'] = Variable<int>(academicProfileID.value);
    }
    if (grade.present) {
      map['grade'] = Variable<String>(grade.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (submissionDate.present) {
      map['submission_date'] = Variable<DateTime>(submissionDate.value);
    }
    if (givenDate.present) {
      map['given_date'] = Variable<DateTime>(givenDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssessmentsCompanion(')
          ..write('id: $id, ')
          ..write('academicProfileID: $academicProfileID, ')
          ..write('grade: $grade, ')
          ..write('title: $title, ')
          ..write('submissionDate: $submissionDate, ')
          ..write('givenDate: $givenDate')
          ..write(')'))
        .toString();
  }
}

class $AssessmentsTable extends Assessments
    with TableInfo<$AssessmentsTable, Assessment> {
  final GeneratedDatabase _db;
  final String _alias;
  $AssessmentsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _academicProfileIDMeta =
      const VerificationMeta('academicProfileID');
  GeneratedIntColumn _academicProfileID;
  @override
  GeneratedIntColumn get academicProfileID =>
      _academicProfileID ??= _constructAcademicProfileID();
  GeneratedIntColumn _constructAcademicProfileID() {
    return GeneratedIntColumn(
      'academic_profile_i_d',
      $tableName,
      false,
    );
  }

  final VerificationMeta _gradeMeta = const VerificationMeta('grade');
  GeneratedTextColumn _grade;
  @override
  GeneratedTextColumn get grade => _grade ??= _constructGrade();
  GeneratedTextColumn _constructGrade() {
    return GeneratedTextColumn('grade', $tableName, false,
        minTextLength: 1, maxTextLength: 2);
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn('title', $tableName, false, minTextLength: 1);
  }

  final VerificationMeta _submissionDateMeta =
      const VerificationMeta('submissionDate');
  GeneratedDateTimeColumn _submissionDate;
  @override
  GeneratedDateTimeColumn get submissionDate =>
      _submissionDate ??= _constructSubmissionDate();
  GeneratedDateTimeColumn _constructSubmissionDate() {
    return GeneratedDateTimeColumn(
      'submission_date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _givenDateMeta = const VerificationMeta('givenDate');
  GeneratedDateTimeColumn _givenDate;
  @override
  GeneratedDateTimeColumn get givenDate => _givenDate ??= _constructGivenDate();
  GeneratedDateTimeColumn _constructGivenDate() {
    return GeneratedDateTimeColumn(
      'given_date',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, academicProfileID, grade, title, submissionDate, givenDate];
  @override
  $AssessmentsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'assessments';
  @override
  final String actualTableName = 'assessments';
  @override
  VerificationContext validateIntegrity(Insertable<Assessment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('academic_profile_i_d')) {
      context.handle(
          _academicProfileIDMeta,
          academicProfileID.isAcceptableOrUnknown(
              data['academic_profile_i_d'], _academicProfileIDMeta));
    } else if (isInserting) {
      context.missing(_academicProfileIDMeta);
    }
    if (data.containsKey('grade')) {
      context.handle(
          _gradeMeta, grade.isAcceptableOrUnknown(data['grade'], _gradeMeta));
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('submission_date')) {
      context.handle(
          _submissionDateMeta,
          submissionDate.isAcceptableOrUnknown(
              data['submission_date'], _submissionDateMeta));
    } else if (isInserting) {
      context.missing(_submissionDateMeta);
    }
    if (data.containsKey('given_date')) {
      context.handle(_givenDateMeta,
          givenDate.isAcceptableOrUnknown(data['given_date'], _givenDateMeta));
    } else if (isInserting) {
      context.missing(_givenDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Assessment map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Assessment.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $AssessmentsTable createAlias(String alias) {
    return $AssessmentsTable(_db, alias);
  }
}

abstract class _$CompendiumDatabase extends GeneratedDatabase {
  _$CompendiumDatabase(QueryExecutor e)
      : super(SqlTypeSystem.defaultInstance, e);
  $PeopleTable _people;
  $PeopleTable get people => _people ??= $PeopleTable(this);
  $AcademicProfilesTable _academicProfiles;
  $AcademicProfilesTable get academicProfiles =>
      _academicProfiles ??= $AcademicProfilesTable(this);
  $AssessmentsTable _assessments;
  $AssessmentsTable get assessments => _assessments ??= $AssessmentsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [people, academicProfiles, assessments];
}
