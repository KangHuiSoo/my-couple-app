import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_couple_app/data/model/place/place.dart';

class FirestorePlaceService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Place> addPlace(Place place) async {
    await firestore.collection("myPlace").doc().set(place.toJson());
    return place;
  }

  Future<List<Place>> fetchPlaceByCoupleId() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection("myPlace").get();
    List<Place> result = snapshot.docs
        .map(
          (e) => Place(
            id: e['id'],
            placeName: e['placeName'],
            categoryName: e['categoryName'],
            categoryGroupCode: e['categoryGroupCode'],
            categoryGroupName: e['categoryGroupName'],
            phone: e['phone'],
            addressName: e['addressName'],
            roadAddressName: e['roadAddressName'],
            x: e['x'],
            y: e['y'],
            placeUrl: e['placeUrl'],
            distance: e['distance'],
          ),
        )
        .toList();

    return result;
  }
}
