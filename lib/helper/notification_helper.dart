import 'dart:math';

import 'package:flutter_fundamental_final_app/data/api/api_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as https;

class NotificationHelper {
  final String _channelId = "01";
  final String _channelName = "channel_01";
  final String _channelDesc = "dicoding channel";

  static final NotificationHelper _instance = NotificationHelper._internal();

  factory NotificationHelper() => _instance;

  NotificationHelper._internal();

  Future<void> initNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {},
    );
  }

  Future<void> showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    final service = ApiService(http: https.Client());
    final data = await service.getAllRestaurants();

    var randomIndex = Random().nextInt(data.restaurants.length);
    final selectedData = data.restaurants[randomIndex];

    await flutterLocalNotificationsPlugin.show(
      randomIndex,
      selectedData.name,
      selectedData.description,
      platformChannelSpecifics,
      payload: 'plain notification',
    );
  }
}
