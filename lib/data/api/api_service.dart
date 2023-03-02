import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../common/constants/constants.dart';
import '../model/local_restaurant_detail_model.dart';
import '../model/local_restaurant_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  ApiService._internal();

  Future<LocalRestaurantModel> getAllRestaurants() async {
    final response = await http.get(Uri.parse("${Constants.baseUrl}/list"));

    if (response.statusCode == 200) {
      return LocalRestaurantModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load restaurants");
    }
  }

  Future<LocalRestaurantDetailModel> getDetailRestaurant(String id) async {
    final response =
        await http.get(Uri.parse("${Constants.baseUrl}/detail/$id"));

    if (response.statusCode == 200) {
      return LocalRestaurantDetailModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load restaurant detail");
    }
  }

  Future<LocalRestaurantModel> searchRestaurants(String query) async {
    final response =
        await http.get(Uri.parse("${Constants.baseUrl}/search?q=$query"));

    if (response.statusCode == 200) {
      return LocalRestaurantModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to search restaurants");
    }
  }
}
