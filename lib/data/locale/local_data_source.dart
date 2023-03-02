import 'package:flutter_fundamental_final_app/data/locale/hive_model/list_restaurants_hive_model.dart';
import 'package:flutter_fundamental_final_app/data/locale/hive_model/restaurant_hive_model.dart';
import 'package:flutter_fundamental_final_app/data/model/restaurant_detail_model.dart';
import 'package:flutter_fundamental_final_app/data/model/restaurant_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalDataSource {
  static final LocalDataSource _instance = LocalDataSource._internal();

  LocalDataSource._internal();

  factory LocalDataSource() => _instance;

  final String _boxName = "BOOKMARK_BOX";
  final String _restaurantKey = "RESTAURANT_KEY";

  late Box<ListRestaurantsHiveModel> _box;

  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ListRestaurantsHiveModelAdapter());
    Hive.registerAdapter(RestaurantHiveModelAdapter());

    _box = await Hive.openBox<ListRestaurantsHiveModel>(_boxName);
  }

  Future<List<RestaurantModel>> getAllSavedRestaurant() async {
    final data = _box.get(
      _restaurantKey,
      defaultValue: ListRestaurantsHiveModel(
        restaurants: [],
      ),
    );

    if (data != null) {
      List<RestaurantModel> tempList = [];

      tempList.addAll(data.restaurants.map(
        (e) => RestaurantModel(
          id: e.id,
          name: e.name,
          description: e.description,
          city: e.city,
          address: e.address,
          pictureId: e.pictureId,
          rating: e.rating,
        ),
      ));

      return tempList;
    } else {
      throw Exception("Hive error");
    }
  }

  Future<void> saveRestaurant(RestaurantDetailModel e) async {
    final data = _box.get(
      _restaurantKey,
      defaultValue: ListRestaurantsHiveModel(
        restaurants: [],
      ),
    );

    if (data != null) {
      final dataExist = data.restaurants.where((element) => element.id == e.id);

      if (dataExist.isEmpty) {
        data.restaurants.add(
          RestaurantHiveModel(
            id: e.id,
            name: e.name,
            description: e.description,
            city: e.city,
            address: e.address,
            pictureId: e.pictureId,
            rating: e.rating,
          ),
        );

        await data.save();
      }
    } else {
      throw Exception("Hive error");
    }
  }

  Future<void> deleteRestaurant(String id) async {
    final data = _box.get(
      _restaurantKey,
      defaultValue: ListRestaurantsHiveModel(
        restaurants: [],
      ),
    );

    if (data != null) {
      data.restaurants.removeWhere((element) => element.id == id);
      await data.save();
    } else {
      throw Exception("Hive error");
    }
  }

  bool checkIsSaved(String id) {
    final data = _box.get(
      _restaurantKey,
      defaultValue: ListRestaurantsHiveModel(
        restaurants: [],
      ),
    );

    if (data != null) {
      final dataFound = data.restaurants.where((element) => element.id == id);

      if (dataFound.isNotEmpty) {
        return true;
      }

      return false;
    } else {
      throw Exception("Hive error");
    }
  }
}
