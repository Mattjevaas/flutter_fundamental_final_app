import 'package:flutter/material.dart';
import 'package:flutter_fundamental_final_app/data/locale/local_data_source.dart';

import '../common/enumeration/result_state.dart';
import '../data/api/api_service.dart';
import '../data/model/local_restaurant_detail_model.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService _apiService;
  final LocalDataSource _localDataSource;
  final String _restaurantId;

  RestaurantDetailProvider({
    required ApiService apiService,
    required LocalDataSource localDataSource,
    required String restaurantId,
  })  : _apiService = apiService,
        _localDataSource = localDataSource,
        _restaurantId = restaurantId {
    _getRestaurantDetail(_restaurantId);
  }

  late LocalRestaurantDetailModel _restaurantsData;
  late ResultState _state;

  String _message = '';
  bool _isBookmarked = false;

  String get restaurantId => _restaurantId;

  LocalRestaurantDetailModel get restaurantsData => _restaurantsData;

  ResultState get state => _state;

  String get message => _message;

  bool get isBookmarked => _isBookmarked;

  Future<void> _getRestaurantDetail(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final data = await _apiService.getDetailRestaurant(id);

      if (data.restaurant == null) {
        _state = ResultState.noData;
        _message = "Empty Data";
        notifyListeners();
      } else {
        _state = ResultState.hasData;
        _restaurantsData = data;
        notifyListeners();

        _checkIsBookmarked();
      }
    } catch (e) {
      final localData = _localDataSource.getRestaurantById(id);

      if (localData != null) {
        _state = ResultState.hasData;
        _restaurantsData = LocalRestaurantDetailModel(
          error: false,
          message: "",
          restaurant: localData,
        );
        notifyListeners();

        _checkIsBookmarked();
      } else {
        _state = ResultState.error;
        _message = 'Error : $e';
        notifyListeners();
      }
    }
  }

  void _checkIsBookmarked() {
    if (_state == ResultState.hasData) {
      _isBookmarked = _localDataSource.checkIsSaved(_restaurantId);
      notifyListeners();
    }
  }

  Future<void> bookMark() async {
    if (_state == ResultState.hasData) {
      if (!_isBookmarked) {
        await _localDataSource.saveRestaurant(_restaurantsData.restaurant!);
      } else {
        await _localDataSource.deleteRestaurant(_restaurantId);
      }

      _checkIsBookmarked();
    }
  }

  Future<void> refreshData() async {
    _getRestaurantDetail(_restaurantId);
  }
}
