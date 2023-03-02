import 'package:flutter_fundamental_final_app/data/locale/hive_model/category_hive_model.dart';
import 'package:flutter_fundamental_final_app/data/locale/hive_model/list_restaurants_hive_model.dart';
import 'package:flutter_fundamental_final_app/data/locale/hive_model/menu_hive_model.dart';
import 'package:flutter_fundamental_final_app/data/locale/hive_model/restaurant_detail_hive_model.dart';
import 'package:flutter_fundamental_final_app/data/locale/hive_model/restaurant_hive_model.dart';
import 'package:flutter_fundamental_final_app/data/model/restaurant_detail_model.dart';
import 'package:flutter_fundamental_final_app/data/model/restaurant_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/category_model.dart';
import '../model/menu_model.dart';

class LocalDataSource {
  static final LocalDataSource _instance = LocalDataSource._internal();

  LocalDataSource._internal();

  factory LocalDataSource() => _instance;

  final String _boxListName = "BOOKMARK_BOX";
  final String _boxDetailName = "BOOKMARK_DETAIL_BOX";
  final String _restaurantKey = "RESTAURANT_KEY";

  late Box<ListRestaurantsHiveModel> _boxList;
  late Box<RestaurantDetailHiveModel> _boxDetail;

  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ListRestaurantsHiveModelAdapter());
    Hive.registerAdapter(RestaurantHiveModelAdapter());
    Hive.registerAdapter(CategoryHiveModelAdapter());
    Hive.registerAdapter(MenuHiveModelAdapter());
    Hive.registerAdapter(RestaurantDetailHiveModelAdapter());

    _boxList = await Hive.openBox<ListRestaurantsHiveModel>(_boxListName);
    _boxDetail = await Hive.openBox<RestaurantDetailHiveModel>(_boxDetailName);
  }

  Future<List<RestaurantModel>> getAllSavedRestaurant() async {
    final data = _boxList.get(
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

  RestaurantDetailModel? getRestaurantById(String id) {
    final data = _boxDetail.get(id);

    if (data != null) {
      return RestaurantDetailModel(
        id: data.id,
        name: data.name,
        description: data.description,
        city: data.city,
        address: data.address,
        pictureId: data.pictureId,
        rating: data.rating,
        categories: List<CategoryModel>.from(
          data.categories.map((e) => CategoryModel(name: e.name)),
        ),
        menus: MenuModel(
          drinks: List.from(
            data.menus.drinks.map((e) => CategoryModel(name: e.name)),
          ),
          foods: List.from(
            data.menus.foods.map((e) => CategoryModel(name: e.name)),
          ),
        ),
        customerReviews: [],
      );
    }

    return null;
  }

  Future<void> saveRestaurant(RestaurantDetailModel e) async {
    final data = _boxList.get(
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

    final dataTwo = _boxDetail.get(e.id);

    if (dataTwo == null) {
      _boxDetail.put(
        e.id,
        RestaurantDetailHiveModel(
          id: e.id,
          name: e.name,
          description: e.description,
          city: e.city,
          address: e.address,
          pictureId: e.pictureId,
          rating: e.rating,
          categories: List<CategoryHiveModel>.from(
            e.categories.map((e) => CategoryHiveModel(name: e.name)),
          ),
          menus: MenuHiveModel(
            drinks: List.from(
              e.menus.drinks.map((e) => CategoryHiveModel(name: e.name)),
            ),
            foods: List.from(
              e.menus.foods.map((e) => CategoryHiveModel(name: e.name)),
            ),
          ),
        ),
      );
    }
  }

  Future<void> deleteRestaurant(String id) async {
    final data = _boxList.get(
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

    final dataTwo = _boxDetail.get(id);

    if (dataTwo != null) {
      _boxDetail.delete(id);
    }
  }

  bool checkIsSaved(String id) {
    final data = _boxList.get(
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
