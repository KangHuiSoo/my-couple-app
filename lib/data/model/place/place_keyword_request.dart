class PlaceKeywordRequest {
  final String keyword;
  final String? categoryGroupCode;
  final String? x;
  final String? y;
  final int? radius;

  PlaceKeywordRequest({
    required this.keyword,
    this.categoryGroupCode,
    this.x,
    this.y,
    this.radius,
  });

  // 📌 `family`에서 같은 요청을 같은 값으로 인식하기 위해 `hashCode`와 `==`를 오버라이드
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceKeywordRequest &&
          runtimeType == other.runtimeType &&
          keyword == other.keyword &&
          categoryGroupCode == other.categoryGroupCode &&
          x == other.x &&
          y == other.y &&
          radius == other.radius;

  @override
  int get hashCode =>
      keyword.hashCode ^
      categoryGroupCode.hashCode ^
      x.hashCode ^
      y.hashCode ^
      radius.hashCode;
}
