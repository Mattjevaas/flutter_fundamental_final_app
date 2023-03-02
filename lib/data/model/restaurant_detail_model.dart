import 'package:flutter_fundamental_final_app/data/model/restaurant_model.dart';

import '../../common/constants/constants.dart';
import 'category_model.dart';
import 'customer_review_model.dart';
import 'menu_model.dart';

class RestaurantDetailModel extends RestaurantModel {
  RestaurantDetailModel({
    required String id,
    required String name,
    required String description,
    required String city,
    required String address,
    required String pictureId,
    required double rating,
    required this.categories,
    required this.menus,
    required this.customerReviews,
  }) : super(
          address: address,
          city: city,
          description: description,
          id: id,
          name: name,
          pictureId: pictureId,
          rating: rating,
        );

  final List<CategoryModel> categories;
  final MenuModel menus;
  final List<CustomerReviewModel> customerReviews;

  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) =>
      RestaurantDetailModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        city: json["city"],
        address: json["address"],
        pictureId: "${Constants.imageUrl}/${json["pictureId"]}",
        categories: List<CategoryModel>.from(
            json["categories"].map((x) => CategoryModel.fromJson(x))),
        menus: MenuModel.fromJson(json["menus"]),
        rating: json["rating"]?.toDouble(),
        customerReviews: List<CustomerReviewModel>.from(json["customerReviews"]
            .map((x) => CustomerReviewModel.fromJson(x))),
      );
}
