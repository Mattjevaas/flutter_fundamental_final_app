import 'package:flutter/material.dart';
import 'package:flutter_fundamental_final_app/data/locale/local_data_source.dart';
import 'package:flutter_fundamental_final_app/ui/restaurant_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final locale = LocalDataSource();
  await locale.initHive();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RestaurantListPage(),
    );
  }
}
