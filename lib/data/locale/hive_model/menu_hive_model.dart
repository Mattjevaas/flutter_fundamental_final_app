import 'package:hive/hive.dart';

import 'category_hive_model.dart';

part 'menu_hive_model.g.dart';

@HiveType(typeId: 3)
class MenuHiveModel {
  @HiveField(1)
  final List<CategoryHiveModel> foods;

  @HiveField(2)
  final List<CategoryHiveModel> drinks;

  MenuHiveModel({
    required this.foods,
    required this.drinks,
  });
}
