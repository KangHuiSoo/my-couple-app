import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_couple_app/data/model/place/place.dart';

class FirestorePlaceService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Place> addPlace(Place place) async {
    await firestore.collection("myPlace").doc().set(place.toJson());
    return place;
  }
}
