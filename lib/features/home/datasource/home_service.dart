import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_couple_app/features/place/model/place.dart';

class HomeService {
  Future<List<Place>> fetchNearestUpcomingPlaces(String coupleId) async {
    try {
      final now = DateTime.now();

      final snapshot = await FirebaseFirestore.instance
          .collection('myPlace')
          .where('coupleId', isEqualTo: coupleId)
          .where('selectedDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
          .orderBy('selectedDate')
          .limit(3)
          .get();
      return snapshot.docs.map((doc) => Place.fromJson(doc.data())).toList();
    } catch (e) {
      print('fetchNearestUpcomingPlaces error : $e');
      return [];
    }
  }
}
