import 'package:flutter/material.dart';
import 'package:flutter_fundamental_final_app/ui/restaurant_detail_page.dart';
import 'package:flutter_fundamental_final_app/ui/restaurant_favorite_list_page.dart';
import 'package:flutter_fundamental_final_app/ui/setting_page.dart';
import 'package:provider/provider.dart';

import '../common/enumeration/result_state.dart';
import '../data/api/api_service.dart';
import '../data/model/restaurant_model.dart';
import '../provider/restaurant_provider.dart';
import '../widgets/custom_error_widget.dart';
import '../widgets/restaurant_card.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: ChangeNotifierProvider<RestaurantProvider>(
          create: (_) => RestaurantProvider(apiService: ApiService()),
          child: Container(
            decoration: const BoxDecoration(color: Color(0xfffafafa)),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- Header Title ----
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Restaurant",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          "Recommendation restaurant for you!",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) =>
                                  const RestaurantFavoriteListPage(),
                            ));
                          },
                          icon: const Icon(
                            Icons.bookmark,
                            color: Colors.blue,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SettingPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.settings),
                        )
                      ],
                    )
                  ],
                ),

                // --- Search Text Field ----
                const SizedBox(height: 10.0),
                Consumer<RestaurantProvider>(
                  builder: (context, state, child) {
                    return TextField(
                      controller: state.textEditingController,
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          state.searchRestaurants(value);
                        }
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: "Find restaurant",
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (state.isSearch)
                                IconButton(
                                  onPressed: () {
                                    state.textEditingController.clear();
                                    state.onClearSearch();
                                  },
                                  icon: const Icon(Icons.clear),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              IconButton(
                                onPressed: () {
                                  if (state
                                      .textEditingController.text.isNotEmpty) {
                                    state.searchRestaurants(
                                      state.textEditingController.text,
                                    );
                                  }
                                },
                                icon: const Icon(Icons.search),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // ---- List Card ----
                const SizedBox(height: 20.0),
                Expanded(
                  child: Consumer<RestaurantProvider>(
                    builder: (context, value, child) {
                      if (value.state == ResultState.loading) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircularProgressIndicator(),
                              SizedBox(height: 10),
                              Text(
                                "Finding Restaurant\nPlease Wait...",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      } else if (value.state == ResultState.noData) {
                        return const Center(child: Text("Nothing Found"));
                      } else if (value.state == ResultState.error) {
                        return CustomErrorWidget(
                          refresh: () => value.refreshData,
                        );
                      } else {
                        return ListView.separated(
                          itemBuilder: (context, index) {
                            RestaurantModel data =
                                value.restaurantsData.restaurants[index];

                            return RestaurantCard(
                              restaurantData: data,
                              pushFunction: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => RestaurantDetailPage(
                                      restaurantId: data.id,
                                      heroId: "${data.id}-list",
                                    ),
                                  ),
                                );
                              },
                              heroId: "${data.id}-list",
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 20),
                          itemCount: value.restaurantsData.restaurants.length,
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
