// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datablock.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DatablockDisplayStyleAdapter extends TypeAdapter<DatablockDisplayStyle> {
  @override
  final int typeId = 3;

  @override
  DatablockDisplayStyle read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DatablockDisplayStyle.stacked;
      case 1:
        return DatablockDisplayStyle.flat;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, DatablockDisplayStyle obj) {
    switch (obj) {
      case DatablockDisplayStyle.stacked:
        writer.writeByte(0);
        break;
      case DatablockDisplayStyle.flat:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatablockDisplayStyleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DatablockValueStyleAdapter extends TypeAdapter<DatablockValueStyle> {
  @override
  final int typeId = 5;

  @override
  DatablockValueStyle read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DatablockValueStyle.value;
      case 1:
        return DatablockValueStyle.bar;
      case 2:
        return DatablockValueStyle.textarea;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, DatablockValueStyle obj) {
    switch (obj) {
      case DatablockValueStyle.value:
        writer.writeByte(0);
        break;
      case DatablockValueStyle.bar:
        writer.writeByte(1);
        break;
      case DatablockValueStyle.textarea:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatablockValueStyleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      metadata: fields[4] as DatablockMetadata,
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

class DatablockMetadataAdapter extends TypeAdapter<DatablockMetadata> {
  @override
  final int typeId = 4;

  @override
  DatablockMetadata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DatablockMetadata(
      fields[1] as bool,
      suggestedChild: fields[4] as Datablock,
      valueStyle: fields[3] as DatablockValueStyle,
      displayStyle: fields[0] as DatablockDisplayStyle,
      timeCreated: fields[2] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, DatablockMetadata obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.displayStyle)
      ..writeByte(1)
      ..write(obj.isCategory)
      ..writeByte(2)
      ..write(obj.timeCreated)
      ..writeByte(3)
      ..write(obj.valueStyle)
      ..writeByte(4)
      ..write(obj.suggestedChild);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatablockMetadataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
