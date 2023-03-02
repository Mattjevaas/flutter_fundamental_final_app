import 'category_model.dart';

class MenuModel {
  MenuModel({
    required this.foods,
    required this.drinks,
  });

  final List<CategoryModel> foods;
  final List<CategoryModel> drinks;

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
        foods: List<CategoryModel>.from(
            json["foods"].map((x) => CategoryModel.fromJson(x))),
        drinks: List<CategoryModel>.from(
            json["drinks"].map((x) => CategoryModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
        "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
      };
}
