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
      fields[0] as String,
      fields[3] as String,
      colorValue: fields[1] as int,
      children: (fields[2] as List)?.cast<Datablock>(),
      metadata: (fields[4] as Map)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Datablock obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.colorValue)
      ..writeByte(2)
      ..write(obj.children)
      ..writeByte(3)
      ..write(obj.value)
      ..writeByte(4)
      ..write(obj.metadata);
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
