import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/map_util.dart';
import '../../model/place_request.dart';
import '../../model/place_response.dart';
import '../core/repository_provider.dart';

final placesByCategoryProvider =
    FutureProvider.autoDispose.family<PlaceResponse, PlaceRequest>(
  (ref, request) async {
    final repository = ref.read(placeRepositoryProvider);

    // 📌 API 요청 후 데이터 가져오기
    PlaceResponse response = await repository.getPlaces(
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
