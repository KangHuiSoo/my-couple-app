import 'package:cloud_firestore/cloud_firestore.dart';

class Place {
  final String id;
  final String placeName;
  final String categoryName;
  final String categoryGroupCode;
  final String categoryGroupName;
  final String phone;
  final String addressName;
  final String roadAddressName;
  final String x;
  final String y;
  final String placeUrl;
  final String distance;
  final DateTime? selectedDate;
  final String? coupleId;
  final Map<String, int>? userRatings;

  Place({
    required this.id,
    required this.placeName,
    required this.categoryName,
    required this.categoryGroupCode,
    required this.categoryGroupName,
    required this.phone,
    required this.addressName,
    required this.roadAddressName,
    required this.x,
    required this.y,
    required this.placeUrl,
    required this.distance,
    this.selectedDate,
    this.coupleId,
    this.userRatings,
  });

  factory Place.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Place(
      id: doc.id,
      placeName: data['placeName'] ?? '',
      categoryName: data['categoryName'] ?? '',
      categoryGroupCode: data['categoryGroupCode'] ?? '',
      categoryGroupName: data['categoryGroupName'] ?? '',
      phone: data['phone'] ?? '',
      addressName: data['addressName'] ?? '',
      roadAddressName: data['roadAddressName'] ?? '',
      x: data['x'] ?? '',
      y: data['y'] ?? '',
      placeUrl: data['placeUrl'] ?? '',
      distance: data['distance'] ?? '',
      selectedDate: (data['selectedDate'] as Timestamp?)?.toDate(),
      coupleId: data['coupleId'],
      userRatings: (data['userRatings'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, (value as num).toInt()),
      ),
    );
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] ?? '',
      placeName: json['placeName'] ?? '',
      categoryName: json['categoryName'] ?? '',
      categoryGroupCode: json['categoryGroupCode'] ?? '',
      categoryGroupName: json['categoryGroupName'] ?? '',
      phone: json['phone'] ?? '',
      addressName: json['addressName'] ?? '',
      roadAddressName: json['roadAddressName'] ?? '',
      y: json['y'] ?? '',
      x: json['x'] ?? '',
      placeUrl: json['placeUrl'] ?? '',
      distance: json['distance'] ?? '',
      selectedDate: json['selectedDate'] != null
          ? (json['selectedDate'] as Timestamp).toDate()
          : null,
      coupleId: json['coupleId'] ?? '',
      userRatings: json['userRatings'] != null
          ? Map<String, int>.from(json['userRatings'])
          : null,
    );
  }

  // 📌 ✅ JSON 변환 메서드 추가
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'placeName': placeName,
      'categoryName': categoryName,
      'categoryGroupCode': categoryGroupCode,
      'categoryGroupName': categoryGroupName,
      'phone': phone,
      'addressName': addressName,
      'roadAddressName': roadAddressName,
      'x': x,
      'y': y,
      'placeUrl': placeUrl,
      'distance': distance,
      'selectedDate': selectedDate,
      'coupleId': coupleId,
      'userRatings': userRatings
    };
  }

  Place copyWith({DateTime? selectedDate, String? coupleId}) {
    return Place(
        id: id,
        placeName: placeName,
        categoryName: categoryName,
        categoryGroupCode: categoryGroupCode,
        categoryGroupName: categoryGroupName,
        phone: phone,
        addressName: addressName,
        roadAddressName: roadAddressName,
        x: x,
        y: y,
        placeUrl: placeUrl,
        distance: distance,
        selectedDate: selectedDate ?? this.selectedDate,
        coupleId: coupleId ?? this.coupleId,
        userRatings: userRatings ?? userRatings);
  }

  @override
  String toString() {
    return 'Place{id: $id, placeName: $placeName, categoryName: $categoryName, categoryGroupCode: $categoryGroupCode, categoryGroupName: $categoryGroupName, phone: $phone, addressName: $addressName, roadAddressName: $roadAddressName, x: $x, y: $y, placeUrl: $placeUrl, distance: $distance, selectedDate: $selectedDate, coupleId: $coupleId, userRatings: $userRatings}';
  }
}
