import 'package:flutter/material.dart';

import '../data/model/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel _restaurantData;
  final Function _pushFunction;
  final String _heroId;

  const RestaurantCard({
    super.key,
    required RestaurantModel restaurantData,
    required Function pushFunction,
    required String heroId,
  })  : _restaurantData = restaurantData,
        _pushFunction = pushFunction,
        _heroId = heroId;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: ValueKey(_restaurantData.id.toString()),
      elevation: 8,
      shadowColor: Colors.black38,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Ink(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: InkWell(
          onTap: () {
            _pushFunction();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Hero(
                    tag: _heroId,
                    child: Image.network(
                      _restaurantData.pictureId,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return const CircularProgressIndicator();
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _restaurantData.name,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 5.0),
                          Row(
                            children: [
                              const Icon(
                                Icons.pin_drop,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                              const SizedBox(width: 4.0),
                              Expanded(
                                child: Text(
                                  _restaurantData.city,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 35.0),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 20,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            _restaurantData.rating.toString(),
                            style: Theme.of(context).textTheme.labelMedium,
                          )
                        ],
                      )
                    ],
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
