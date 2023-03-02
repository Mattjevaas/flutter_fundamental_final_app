// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_detail_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestaurantDetailHiveModelAdapter
    extends TypeAdapter<RestaurantDetailHiveModel> {
  @override
  final int typeId = 4;

  @override
  RestaurantDetailHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantDetailHiveModel(
      id: fields[1] as String,
      name: fields[2] as String,
      description: fields[3] as String,
      city: fields[4] as String,
      address: fields[5] as String,
      pictureId: fields[6] as String,
      rating: fields[7] as double,
      categories: (fields[8] as List).cast<CategoryHiveModel>(),
      menus: fields[9] as MenuHiveModel,
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantDetailHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.city)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.pictureId)
      ..writeByte(7)
      ..write(obj.rating)
      ..writeByte(8)
      ..write(obj.categories)
      ..writeByte(9)
      ..write(obj.menus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantDetailHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
