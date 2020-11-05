// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datablock.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DatablockAdapter extends TypeAdapter<Datablock> {
  @override
  final int typeId = 2;

  @override
  Datablock read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Datablock(
      name: fields[0] as String,
      colourValue: fields[1] as int,
    )..attributes = (fields[2] as Map)?.cast<String, String>();
  }

  @override
  void write(BinaryWriter writer, Datablock obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.colourValue)
      ..writeByte(2)
      ..write(obj.attributes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatablockAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
