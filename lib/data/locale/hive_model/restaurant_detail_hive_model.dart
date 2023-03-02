import 'package:flutter_fundamental_final_app/data/locale/hive_model/category_hive_model.dart';
import 'package:flutter_fundamental_final_app/data/locale/hive_model/menu_hive_model.dart';
import 'package:hive/hive.dart';

part 'restaurant_detail_hive_model.g.dart';

@HiveType(typeId: 4)
class RestaurantDetailHiveModel extends HiveObject {
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

  @HiveField(8)
  final List<CategoryHiveModel> categories;

  @HiveField(9)
  final MenuHiveModel menus;

  RestaurantDetailHiveModel({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
    required this.categories,
    required this.menus,
  });
}
