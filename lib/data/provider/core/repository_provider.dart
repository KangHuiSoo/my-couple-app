import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../datasource/firestore_place_service.dart';
import '../../datasource/kakao_api_service.dart';
import '../../repository/place_repository.dart';
import '../../../core/services/cache_service.dart';
import '../../model/place/place_response.dart';

// 캐시 서비스 프로바이더
final cacheServiceProvider = Provider<CacheService<PlaceResponse>>((ref) {
  return CacheService<PlaceResponse>();
});

// 장소 리포지토리 프로바이더
final placeRepositoryProvider = Provider<PlaceRepository>((ref) {
  return PlaceRepository(
    KakaoApiService(),
    FirestorePlaceService(),
    ref.watch(cacheServiceProvider),
  );
});
