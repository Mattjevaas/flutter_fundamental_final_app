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
  late ResultState _state;

  final List<RestaurantModel> _restaurantsData = [];
  final List<RestaurantModel> _searchData = [];
  bool _isSearch = false;
  String _message = '';

  List<RestaurantModel> get restaurantsData => _restaurantsData;

  ResultState get state => _state;

  String get message => _message;

  bool get isSearch => _isSearch;

  List<RestaurantModel> get searchData => _searchData;

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
        _restaurantsData.clear();
        _state = ResultState.hasData;
        _restaurantsData.addAll(data);
        notifyListeners();
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error : $e';
      notifyListeners();
    }
  }

  void searchRestaurants(String query) {
    _searchData.clear();
    _isSearch = true;

    if (query.isNotEmpty && _state == ResultState.hasData) {
      final data = _restaurantsData.where(
        (element) => element.name.toLowerCase().contains(query.toLowerCase()),
      );

      if (data.isEmpty) {
        _state = ResultState.noData;
      } else {
        _state = ResultState.hasData;
        _searchData.addAll(data);
      }
    } else if (query.isEmpty) {
      onClearSearch();
    }

    notifyListeners();
  }

  void onClearSearch() {
    if (_restaurantsData.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
    }

    _textEditingController.clear();
    _searchData.clear();
    _isSearch = false;

    notifyListeners();
  }

  Future<void> refreshData() async {
    await _getAllFavoriteRestaurants();
  }
}
