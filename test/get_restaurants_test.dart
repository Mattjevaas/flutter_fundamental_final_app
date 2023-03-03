import 'package:flutter_fundamental_final_app/common/constants/constants.dart';
import 'package:flutter_fundamental_final_app/data/api/api_service.dart';
import 'package:flutter_fundamental_final_app/data/model/local_restaurant_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_restaurants_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group(
    'getRestaurants',
    () {
      // --- Test http success 200 ---
      test("returns a Restaurants if the http call completes successfully",
          () async {
        final client = MockClient();
        final service = ApiService(http: client);

        when(client.get(Uri.parse("${Constants.baseUrl}/list"))).thenAnswer(
          (_) async => http.Response('''{
            "error": false,
            "message": "success",
            "count": 20,
            "restaurants": [
                {
                    "id": "rqdv5juczeskfw1e867",
                    "name": "Melting Pot",
                    "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
                    "pictureId": "14",
                    "city": "Medan",
                    "rating": 4.2
                },
                {
                    "id": "s1knt6za9kkfw1e867",
                    "name": "Kafe Kita",
                    "description": "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
                    "pictureId": "25",
                    "city": "Gorontalo",
                    "rating": 4
                }
            ]
        }''', 200),
        );

        expect(await service.getAllRestaurants(), isA<LocalRestaurantModel>());
      });

      // --- Test http failed 404 ---
      test("returns an exception if the http call completes with an error",
          () async {
        final client = MockClient();
        final service = ApiService(http: client);

        when(client.get(Uri.parse("${Constants.baseUrl}/list"))).thenAnswer(
          (_) async => http.Response('Not Found', 404),
        );

        expect(service.getAllRestaurants(), throwsException);
      });
    },
  );
}
