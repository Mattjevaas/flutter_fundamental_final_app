// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MenuHiveModelAdapter extends TypeAdapter<MenuHiveModel> {
  @override
  final int typeId = 3;

  @override
  MenuHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MenuHiveModel(
      foods: (fields[1] as List).cast<CategoryHiveModel>(),
      drinks: (fields[2] as List).cast<CategoryHiveModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, MenuHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.foods)
      ..writeByte(2)
      ..write(obj.drinks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
