import 'package:flutter/material.dart';
import 'package:flutter_fundamental_final_app/data/locale/local_data_source.dart';
import 'package:flutter_fundamental_final_app/provider/restaurant_favorite_provider.dart';
import 'package:provider/provider.dart';

import '../common/enumeration/result_state.dart';
import '../data/model/restaurant_model.dart';
import '../widgets/custom_error_widget.dart';
import '../widgets/restaurant_card.dart';

class RestaurantFavoriteListPage extends StatelessWidget {
  const RestaurantFavoriteListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Restaurant"),
        backgroundColor: Colors.black,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: ChangeNotifierProvider<RestaurantFavoriteProvider>(
          create: (_) =>
              RestaurantFavoriteProvider(localDataSource: LocalDataSource()),
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
                          "Favorite Restaurant",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          "Your saved restaurant",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),

                // --- Search Text Field ----
                const SizedBox(height: 10.0),
                Consumer<RestaurantFavoriteProvider>(
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
                  child: Consumer<RestaurantFavoriteProvider>(
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
                        return const CustomErrorWidget(
                          refresh: null,
                        );
                      } else {
                        return ListView.separated(
                          itemBuilder: (context, index) {
                            RestaurantModel data = value.restaurantsData[index];

                            return RestaurantCard(
                              restaurantData: data,
                              heroId: "${data.id}-fav",
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 20),
                          itemCount: value.restaurantsData.length,
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
