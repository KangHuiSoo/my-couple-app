import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_couple_app/core/ui/component/custom_text_field.dart';

import '../../data/provider/place/place_notifier.dart';

class PlaceSearchScreen extends ConsumerStatefulWidget {
  const PlaceSearchScreen({super.key});

  @override
  _PlaceSearchScreenState createState() => _PlaceSearchScreenState();
}

class _PlaceSearchScreenState extends ConsumerState<PlaceSearchScreen> {
  TextEditingController searchController = TextEditingController();

  void _searchPlaces() {
    final notifier = ref.read(placesProvider.notifier);
    notifier.searchPlaces(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(placesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('장소 검색'),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CustomTextField(
                      controller: searchController,
                      hintText: '이곳에서 검색 하세요',
                      color: Color(0xFFF9F9F9),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _searchPlaces,
                  icon: Icon(Icons.search),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> place = places[index];
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.location_on_rounded),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                place["name"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              Text(
                                place["address"],
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        Text(place['distance'])
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}