import 'package:flutter/material.dart';
import 'package:flutter_fundamental_final_app/data/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider extends ChangeNotifier {
  final ApiService _apiService;
  final Future<SharedPreferences> _preferences;

  SettingProvider({
    required ApiService apiService,
    required Future<SharedPreferences> preferences,
  })  : _apiService = apiService,
        _preferences = preferences {
    _checkNotificationState();
  }

  final String _prefKey = "NOTIFICATION_KEY";
  bool _isOn = false;

  bool get isOn => _isOn;

  Future<void> _checkNotificationState() async {
    final prefs = await _preferences;
    final state = prefs.getBool(_prefKey);

    if (state != null) {
      _isOn = state;
      notifyListeners();
    }
  }

  Future<void> onChangeState() async {
    final prefs = await _preferences;
    await prefs.setBool(_prefKey, !_isOn);

    _isOn = !isOn;
    notifyListeners();
  }
}
