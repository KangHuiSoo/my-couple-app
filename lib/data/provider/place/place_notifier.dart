import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_couple_app/data/model/place_keyword_request.dart';
import 'package:my_couple_app/data/provider/place/place_provider.dart';

class PlacesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final Ref ref;

  PlacesNotifier(this.ref) : super([]);

  Future<void> searchPlaces(String keyword) async {
    if (keyword.isEmpty) return;

    final response = await ref.read(
        placesByKeywordProvider(PlaceKeywordRequest(keyword: keyword)).future);

    if (response != null && response.places.isNotEmpty) {
      state = response.places
          .map((place) => {
                "name": place.placeName,
                "address": place.roadAddressName,
                "distance": place.distance
              })
          .toList();
    }
  }
}

final placesProvider =
    StateNotifierProvider<PlacesNotifier, List<Map<String, dynamic>>>((ref) {
  return PlacesNotifier(ref);
});
