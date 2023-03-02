import 'package:flutter/material.dart';
import 'package:flutter_fundamental_final_app/data/locale/local_data_source.dart';
import 'package:provider/provider.dart';

import '../common/enumeration/result_state.dart';
import '../data/api/api_service.dart';
import '../provider/restaurant_detail_provider.dart';
import '../widgets/custom_error_widget.dart';

class RestaurantDetailPage extends StatelessWidget {
  final String _restaurantId;
  final String _heroId;

  const RestaurantDetailPage({
    Key? key,
    required String restaurantId,
    required String heroId,
  })  : _restaurantId = restaurantId,
        _heroId = heroId,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<RestaurantDetailProvider>(
        create: (_) => RestaurantDetailProvider(
          apiService: ApiService(),
          localDataSource: LocalDataSource(),
          restaurantId: _restaurantId,
        ),
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 200,
                  backgroundColor: Colors.black,
                  flexibleSpace: Consumer<RestaurantDetailProvider>(
                    builder: (ctx, value, child) {
                      return FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Hero(
                              tag: _heroId,
                              child: value.state == ResultState.hasData
                                  ? Image.network(
                                      value.restaurantsData.restaurant!
                                          .pictureId,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress != null) {
                                          return const CircularProgressIndicator();
                                        }

                                        return child;
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          "assets/images/placeholder.png",
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      "assets/images/placeholder.png",
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.0, 0.5),
                                  end: Alignment.center,
                                  colors: <Color>[
                                    Color(0x80000000),
                                    Color(0x00000000),
                                  ],
                                ),
                              ),
                            ),
                            if (value.state == ResultState.hasData)
                              Positioned(
                                top: 10,
                                right: 20,
                                child: InkWell(
                                  onTap: () async {
                                    await value.bookMark();
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.bookmark,
                                      color: value.isBookmarked
                                          ? Colors.blue
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(value.state == ResultState.hasData
                            ? value.restaurantsData.restaurant!.name
                            : ""),
                      );
                    },
                  ),
                ),
              ];
            },
            body: Consumer<RestaurantDetailProvider>(
              builder: (context, value, child) {
                if (value.state == ResultState.hasData) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Location ----
                          Text(
                            "Location",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              const Icon(
                                Icons.pin_drop,
                                color: Colors.redAccent,
                              ),
                              const SizedBox(width: 5.0),
                              Expanded(
                                child: Text(
                                  value.restaurantsData.restaurant!.city,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              )
                            ],
                          ),

                          // ---- Categories ----
                          const SizedBox(height: 10.0),
                          Text(
                            "Categories",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            height: 35,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                width: 5.0,
                              ),
                              itemCount: value.restaurantsData.restaurant!
                                  .categories.length,
                              itemBuilder: (context, index) {
                                var data = value.restaurantsData.restaurant!
                                    .categories[index];

                                return Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black12,
                                  ),
                                  child: Text(data.name),
                                );
                              },
                            ),
                          ),

                          // ---- Description ----
                          const SizedBox(height: 20.0),
                          Text(
                            "Description",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            value.restaurantsData.restaurant!.description,
                            textAlign: TextAlign.justify,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),

                          // ---- Food List ----
                          const SizedBox(height: 20.0),
                          Text(
                            "Restaurant's Menu",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          const Divider(),
                          Table(
                            columnWidths: const <int, TableColumnWidth>{
                              0: FlexColumnWidth(),
                              1: FlexColumnWidth(),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: value
                                .restaurantsData.restaurant!.menus.foods
                                .asMap()
                                .entries
                                .map((entry) {
                              int idx = entry.key;
                              String name = entry.value.name;

                              return TableRow(
                                children: [
                                  Text(
                                    idx == 0 ? "Foods" : "",
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "\u2022 $name",
                                  ),
                                ],
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 5.0),
                          const Divider(),
                          const SizedBox(height: 5.0),
                          Table(
                            columnWidths: const <int, TableColumnWidth>{
                              0: FlexColumnWidth(),
                              1: FlexColumnWidth(),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: value
                                .restaurantsData.restaurant!.menus.drinks
                                .asMap()
                                .entries
                                .map(
                              (entry) {
                                int idx = entry.key;
                                String name = entry.value.name;

                                return TableRow(
                                  children: [
                                    Text(
                                      idx == 0 ? "Beverages" : "",
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "\u2022 $name",
                                    ),
                                  ],
                                );
                              },
                            ).toList(),
                          ),
                          const Divider(),
                          const SizedBox(height: 5.0),
                        ],
                      ),
                    ),
                  );
                } else if (value.state == ResultState.loading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text("Loading Data.."),
                      ],
                    ),
                  );
                } else {
                  return CustomErrorWidget(
                    refresh: () => value.refreshData,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
