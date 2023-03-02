import 'package:flutter/material.dart';

import '../common/enumeration/result_state.dart';
import '../data/api/api_service.dart';
import '../data/model/local_restaurant_model.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestaurantProvider({required ApiService apiService})
      : _apiService = apiService {
    _getAllRestaurants();
  }

  final TextEditingController _textEditingController = TextEditingController();

  late LocalRestaurantModel _restaurantsData;
  late ResultState _state;

  bool _isSearch = false;
  String _message = '';

  LocalRestaurantModel get restaurantsData => _restaurantsData;

  ResultState get state => _state;

  String get message => _message;

  bool get isSearch => _isSearch;

  TextEditingController get textEditingController => _textEditingController;

  Future<void> _getAllRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final data = await _apiService.getAllRestaurants();

      if (data.count == 0) {
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

  Future<void> searchRestaurants(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final data = await _apiService.searchRestaurants(query);
      if (data.count == 0) {
        _state = ResultState.noData;
        _message = "Empty Data";
        notifyListeners();
      } else {
        _state = ResultState.hasData;
        _restaurantsData = data;
        notifyListeners();
      }

      _isSearch = true;
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error : $e';
      _isSearch = false;

      notifyListeners();
    }
  }

  Future<void> onClearSearch() async {
    _isSearch = false;

    try {
      await _getAllRestaurants();
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error : $e';
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    _isSearch = false;
    _textEditingController.clear();
    notifyListeners();

    _getAllRestaurants();
  }
}
