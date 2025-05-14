// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abacus_game_state_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AbacusGameStateModelAdapter extends TypeAdapter<AbacusGameStateModel> {
  @override
  final int typeId = 1;

  @override
  AbacusGameStateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AbacusGameStateModel(
      gameName: fields[0] as String,
      playerId: fields[1] as int,
      level: fields[2] as int,
      elapsedTime: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AbacusGameStateModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.gameName)
      ..writeByte(1)
      ..write(obj.playerId)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.elapsedTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AbacusGameStateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
