import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_couple_app/data/model/place_keyword_request.dart';
import '../../../core/utils/map_util.dart';
import '../../model/place.dart';
import '../../model/place_category_request.dart';
import '../../model/place_response.dart';
import '../core/repository_provider.dart';

//마커가 선택된 장소 used place_add_scree.dart
final selectedPlaceProvider = StateProvider<Place?>((ref) => null);

//키워드로 장소 검색 used place_search_scree.dart
final placesByKeywordProvider =
FutureProvider.autoDispose.family<PlaceResponse, PlaceKeywordRequest>(
      (ref, request) async {
    final repository = ref.read(placeRepositoryProvider);

    // 📌 API 요청 후 데이터 가져오기
    PlaceResponse response = await repository.getPlacesByKeyword(
      request.keyword,
      categoryGroupCode: request.categoryGroupCode,
      x: request.x,
      y: request.y,
      radius: request.radius,
    );

    // 📌 검색된 장소의 마커를 추가
    addSearchMarkers(ref, response.places);

    return response;
  },
);

//카테고리 코드로 장소 검색 used place_search_scree.dart
final placesByCategoryProvider =
    FutureProvider.autoDispose.family<PlaceResponse, PlaceCategoryRequest>(
  (ref, request) async {
    final repository = ref.read(placeRepositoryProvider);

    // 📌 API 요청 후 데이터 가져오기
    PlaceResponse response = await repository.getPlacesByCategory(
      request.categoryGroupCode,
      x: request.x,
      y: request.y,
      radius: request.radius,
    );

    // 📌 검색된 장소의 마커를 추가
    addSearchMarkers(ref, response.places);

    return response;
  },
);
