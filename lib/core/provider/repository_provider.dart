import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_couple_app/features/place/model/place_response.dart';
import '../../features/place/datasource/firestore_place_service.dart';
import '../../features/place/datasource/kakao_api_service.dart';
import '../../features/place/repository/place_repository.dart';
import '../services/cache_service.dart';

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
