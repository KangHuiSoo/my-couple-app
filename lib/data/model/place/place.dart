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
  final String? selectedDate;

  Place(
      {required this.id,
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
      this.selectedDate});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      placeName: json['place_name'],
      categoryName: json['category_name'],
      categoryGroupCode: json['category_group_code'],
      categoryGroupName: json['category_group_name'],
      phone: json['phone'],
      addressName: json['address_name'],
      roadAddressName: json['road_address_name'],
      y: json['y'],
      x: json['x'],
      placeUrl: json['place_url'],
      distance: json['distance'],
      selectedDate: json['selectedDate'],
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
      'selectedDate': selectedDate
    };
  }

  Place copyWith({
    String? selectedDate,
  }) {
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
    );
  }
}
