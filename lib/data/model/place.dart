class Place {
  final String id;
  final String placeName;
  final String categoryName;
  final String categoryGroupCode;
  final String categoryGroupName;
  final String phone;
  final String addressName;
  final String roadAddressName;
  final double x;
  final double y;
  final String placeUrl;
  final String distance;

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
  });

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
      y: double.parse(json['y']),
      x: double.parse(json['x']),
      placeUrl: json['place_url'],
      distance: json['distance']
    );
  }
}
