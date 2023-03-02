import 'package:flutter_fundamental_final_app/data/model/restaurant_detail_model.dart';

class LocalRestaurantDetailModel {
  LocalRestaurantDetailModel({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  final bool error;
  final String message;
  final RestaurantDetailModel? restaurant;

  factory LocalRestaurantDetailModel.fromJson(Map<String, dynamic> json) =>
      LocalRestaurantDetailModel(
        error: json["error"],
        message: json["message"],
        restaurant: RestaurantDetailModel.fromJson(json["restaurant"]),
      );
}
