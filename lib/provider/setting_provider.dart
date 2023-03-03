import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fundamental_final_app/data/api/api_service.dart';
import 'package:flutter_fundamental_final_app/helper/date_helper.dart';
import 'package:flutter_fundamental_final_app/helper/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class SettingProvider extends ChangeNotifier {
  final ApiService _apiService;
  final Future<SharedPreferences> _preferences;
  final NotificationHelper _notificationHelper;

  SettingProvider({
    required ApiService apiService,
    required Future<SharedPreferences> preferences,
    required NotificationHelper notificationHelper,
  })  : _apiService = apiService,
        _preferences = preferences,
        _notificationHelper = notificationHelper {
    _checkNotificationState();
  }

  final String _prefKey = "NOTIFICATION_KEY";
  final int _alarmId = 1;

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

    _triggerAlarm(_isOn);
  }

  Future<void> _triggerAlarm(bool state) async {
    if (state) {
      await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        _alarmId,
        _alarmTask,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
        allowWhileIdle: true,
      );
    } else {
      await AndroidAlarmManager.cancel(_alarmId);
    }
  }

  @pragma('vm:entry-point')
  static void _alarmTask() {
    final notificationHelper = NotificationHelper();
    notificationHelper.showNotification(flutterLocalNotificationsPlugin);
  }
}
