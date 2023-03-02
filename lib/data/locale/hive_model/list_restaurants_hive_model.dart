import 'package:flutter_fundamental_final_app/data/locale/hive_model/restaurant_hive_model.dart';
import 'package:hive/hive.dart';

part 'list_restaurants_hive_model.g.dart';

@HiveType(typeId: 0)
class ListRestaurantsHiveModel extends HiveObject {
  @HiveField(1)
  List<RestaurantHiveModel> restaurants;

  ListRestaurantsHiveModel({required this.restaurants});
}
