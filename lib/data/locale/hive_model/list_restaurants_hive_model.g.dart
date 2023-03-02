// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_restaurants_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListRestaurantsHiveModelAdapter
    extends TypeAdapter<ListRestaurantsHiveModel> {
  @override
  final int typeId = 0;

  @override
  ListRestaurantsHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListRestaurantsHiveModel(
      restaurants: (fields[1] as List).cast<RestaurantHiveModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ListRestaurantsHiveModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.restaurants);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListRestaurantsHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
