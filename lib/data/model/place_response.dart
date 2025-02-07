import 'place.dart';

class PlaceResponse {
  final List<Place> places;

  PlaceResponse({required this.places});

  factory PlaceResponse.fromJson(Map<String, dynamic> json) {
    var placesList = (json['documents'] as List).map((item) => Place.fromJson(item)).toList();
    return PlaceResponse(places: placesList);
  }
}