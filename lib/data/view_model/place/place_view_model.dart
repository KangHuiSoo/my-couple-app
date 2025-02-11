import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../datasource/kakao_api_service.dart';
import '../../model/place_request.dart';
import '../../model/place_response.dart';
import '../../repository/place_repository.dart';

// final placesByCategoryProvider = FutureProvider.autoDispose.family<PlaceResponse, String>(
//       (ref, categoryGroupCode) async {
//     final repository = ref.read(placeRepositoryProvider);
//     return repository.getPlaces(categoryGroupCode);
//   },
// );

final placesByCategoryProvider = FutureProvider.autoDispose.family<PlaceResponse, PlaceRequest>(
      (ref, request) async {
    print("✅ 장소 데이터 요청 ==> 카테고리 코드: ${request.categoryGroupCode}, x: ${request.x}, y: ${request.y}, radius: ${request.radius}");

    final repository = ref.read(placeRepositoryProvider);

    // 📌 장소 데이터 요청
    return repository.getPlaces(
      request.categoryGroupCode,
      x: request.x,
      y: request.y,
      radius: request.radius,
    );
  },
);


final placeRepositoryProvider = Provider<PlaceRepository>((ref) {
  return PlaceRepository(KakaoApiService());
});