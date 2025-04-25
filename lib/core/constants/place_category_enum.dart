enum PlaceCategory {
  mart('MT1', '대형마트'),
  convenienceStore('CS2', '편의점'),
  kindergarten('PS3', '어린이집, 유치원'),
  school('SC4', '학교'),
  academy('AC5', '학원'),
  parkingLot('PK6', '주차장'),
  gasStation('OL7', '주유소, 충전소'),
  subwayStation('SW8', '지하철역'),
  bank('BK9', '은행'),
  culturalFacility('CT1', '문화시설'),
  realEstate('AG2', '중개업소'),
  governmentOffice('PO3', '공공기관'),
  touristAttraction('AT4', '관광명소'),
  hotel('AD5', '숙박'),
  restaurant('FD6', '음식점'),
  cafe('CE7', '카페'),
  hospital('HP8', '병원'),
  pharmacy('PM9', '약국');

  final String code;
  final String label;

  const PlaceCategory(this.code, this.label);

  // 📌 한글 카테고리명을 코드로 변환하는 메서드 추가
  static String getCodeByLabel(String label) {
    if (label == null || label.isEmpty) return "CE7"; // ✅ 기본값 반환 (카페)
    return PlaceCategory.values.firstWhere(
          (category) => category.label == label,
      orElse: () => PlaceCategory.cafe, // 기본값: 카페
    ).code;
  }
}