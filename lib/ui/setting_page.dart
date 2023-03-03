import 'package:flutter/material.dart';
import 'package:flutter_fundamental_final_app/data/api/api_service.dart';
import 'package:flutter_fundamental_final_app/provider/setting_provider.dart';
import 'package:http/http.dart' as https;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/notification_helper.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
        backgroundColor: Colors.black,
      ),
      body: ChangeNotifierProvider<SettingProvider>(
        create: (context) => SettingProvider(
          apiService: ApiService(http: https.Client()),
          preferences: SharedPreferences.getInstance(),
          notificationHelper: NotificationHelper(),
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Setting",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Restaurant Notification",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "Enable Notification",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Consumer<SettingProvider>(
                    builder: (context, state, child) {
                      return Switch(
                        value: state.isOn,
                        onChanged: (_) {
                          state.onChangeState();
                        },
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
