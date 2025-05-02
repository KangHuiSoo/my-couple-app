import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_couple_app/features/place/model/place.dart';

class FirestorePlaceService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // 메모리 캐시 추가
  final Map<String, List<Place>> _cache = {};
  final Duration _cacheDuration = Duration(minutes: 10);
  DateTime? _lastFetchTime;

  Future<Place> addPlace(Place place) async {
    // document ID로 장소 ID를 사용하여 한 번의 요청으로 처리
    await firestore.collection("myPlace").doc(place.id).set(place.toJson());
    return place;
  }

  Future<List<Place>> fetchPlaceByCoupleId() async {
    // 캐시가 유효한 경우 캐시된 데이터 반환
    if (_isCacheValid()) {
      return _cache['places'] ?? [];
    }

    final snapshot = await firestore.collection("myPlace").get();
    final places = snapshot.docs.map((e) => Place.fromFirestore(e)).toList();

    // 캐시 업데이트
    _cache['places'] = places;
    _lastFetchTime = DateTime.now();

    return places;
  }

  bool _isCacheValid() {
    if (_lastFetchTime == null || _cache['places'] == null) return false;
    return DateTime.now().difference(_lastFetchTime!) < _cacheDuration;
  }

  // 실시간 장소 목록 리스너
  Stream<List<Place>> listenToPlaces(String? coupleId) {
    return firestore.collection('myPlace')
        .where('coupleId', isEqualTo: coupleId)
        .snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Place.fromFirestore(doc)).toList());
  }
}
