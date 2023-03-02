import 'package:hive/hive.dart';

part 'restaurant_hive_model.g.dart';

@HiveType(typeId: 1)
class RestaurantHiveModel {
  @HiveField(1)
  String id;

  @HiveField(2)
  String name;

  @HiveField(3)
  String description;

  @HiveField(4)
  String city;

  @HiveField(5)
  String address;

  @HiveField(6)
  String pictureId;

  @HiveField(7)
  double rating;

  RestaurantHiveModel({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
  });
}
