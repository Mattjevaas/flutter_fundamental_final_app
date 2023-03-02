import 'package:flutter_fundamental_final_app/data/model/restaurant_model.dart';

class LocalRestaurantModel {
  LocalRestaurantModel({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  final bool error;
  final String message;
  final int count;
  final List<RestaurantModel> restaurants;

  factory LocalRestaurantModel.fromJson(Map<String, dynamic> json) =>
      LocalRestaurantModel(
        error: json["error"],
        message: json["message"] ?? "",
        count: json["count"] ?? json["founded"],
        restaurants: List<RestaurantModel>.from(
            json["restaurants"].map((x) => RestaurantModel.fromJson(x))),
      );
}
