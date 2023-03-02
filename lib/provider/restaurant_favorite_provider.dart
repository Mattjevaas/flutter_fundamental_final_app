import 'package:flutter/material.dart';
import 'package:flutter_fundamental_final_app/data/locale/local_data_source.dart';

import '../common/enumeration/result_state.dart';
import '../data/model/restaurant_model.dart';

class RestaurantFavoriteProvider extends ChangeNotifier {
  final LocalDataSource _localDataSource;

  RestaurantFavoriteProvider({required LocalDataSource localDataSource})
      : _localDataSource = localDataSource {
    _getAllFavoriteRestaurants();
  }

  final TextEditingController _textEditingController = TextEditingController();

  late List<RestaurantModel> _restaurantsData;
  late ResultState _state;

  bool _isSearch = false;
  String _message = '';

  List<RestaurantModel> get restaurantsData => _restaurantsData;

  ResultState get state => _state;

  String get message => _message;

  bool get isSearch => _isSearch;

  TextEditingController get textEditingController => _textEditingController;

  Future<void> _getAllFavoriteRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final data = await _localDataSource.getAllSavedRestaurant();

      if (data.isEmpty) {
        _state = ResultState.noData;
        _message = "Empty Data";
        notifyListeners();
      } else {
        _state = ResultState.hasData;
        _restaurantsData = data;
        notifyListeners();
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error : $e';
      notifyListeners();
    }
  }

  Future<void> searchRestaurants(String query) async {}

  Future<void> onClearSearch() async {}
}
