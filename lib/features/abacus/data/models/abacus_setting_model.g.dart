// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abacus_setting_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AbacusSettingModelAdapter extends TypeAdapter<AbacusSettingModel> {
  @override
  final int typeId = 2;

  @override
  AbacusSettingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AbacusSettingModel(
      playerId: fields[0] as int,
      numberColor: fields[1] as String?,
      backgroundColor: fields[2] as String?,
      name: fields[3] as String?,
      operator: fields[4] as int?,
      level: fields[5] as int?,
      sublevel: fields[6] as int?,
      digit: fields[7] as int?,
      speed: fields[8] as double?,
      rangeEnum: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, AbacusSettingModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.playerId)
      ..writeByte(1)
      ..write(obj.numberColor)
      ..writeByte(2)
      ..write(obj.backgroundColor)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.operator)
      ..writeByte(5)
      ..write(obj.level)
      ..writeByte(6)
      ..write(obj.sublevel)
      ..writeByte(7)
      ..write(obj.digit)
      ..writeByte(8)
      ..write(obj.speed)
      ..writeByte(9)
      ..write(obj.rangeEnum);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AbacusSettingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
