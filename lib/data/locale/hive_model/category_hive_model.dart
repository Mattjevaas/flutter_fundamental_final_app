import 'package:hive/hive.dart';

part 'category_hive_model.g.dart';

@HiveType(typeId: 2)
class CategoryHiveModel {
  @HiveField(1)
  final String name;

  CategoryHiveModel({
    required this.name,
  });
}
