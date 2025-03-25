import 'package:my_couple_app/core/services/cache_service.dart';
import '../datasource/kakao_api_service.dart';
import '../model/place/place_response.dart';
import '../model/place/place.dart';
import '../datasource/firestore_place_service.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 장소 관련 데이터를 관리하는 Repository
/// - Kakao API를 통한 장소 검색
/// - Firestore를 통한 장소 데이터 저장/조회
/// - 캐시를 통한 API 요청 최적화
class PlaceRepository {
  // API 서비스 (카카오 API 호출)
  final KakaoApiService apiService;
  // Firestore 서비스 (데이터베이스 작업)
  final FirestorePlaceService firestoreService;
  // 캐시 서비스 (API 응답 캐싱)
  final CacheService<PlaceResponse> cacheService;

  PlaceRepository(this.apiService, this.firestoreService, this.cacheService);

  /// 커플 ID로 저장된 장소 목록을 조회
  Future<List<Place>> fetchPlaceByCoupleId() async {
    return await firestoreService.fetchPlaceByCoupleId();
  }

  /// 새로운 장소를 추가
  Future<Place> addPlace(Place place) async {
    return await firestoreService.addPlace(place);
  }

  /// 키워드로 장소를 검색
  /// - 캐시된 결과가 있으면 캐시에서 반환
  /// - 없으면 API 호출 후 결과를 캐시에 저장
  Future<PlaceResponse> getPlacesByKeyword(String keyword,
      {String? categoryGroupCode, String? x, String? y, int? radius}) async {
    final cacheKey =
        _generateCacheKey(keyword, categoryGroupCode, x, y, radius);

    // 캐시된 데이터 확인
    final cachedData = cacheService.get(cacheKey);
    if (cachedData != null) {
      print("🔥 캐시된 데이터 반환 (Keyword: $keyword)");
      return cachedData;
    }

    // API 호출
    final response = await apiService.fetchPlacesByKeyword(keyword,
        categoryGroupCode: categoryGroupCode, x: x, y: y, radius: radius);

    // 응답 데이터 캐싱
    cacheService.set(cacheKey, response);
    return response;
  }

  /// 카테고리로 장소를 검색
  /// - 캐시된 결과가 있으면 캐시에서 반환
  /// - 없으면 API 호출 후 결과를 캐시에 저장
  Future<PlaceResponse> getPlacesByCategory(String categoryGroupCode,
      {String? x, String? y, int? radius = 3000}) async {
    final cacheKey = _generateCacheKey(categoryGroupCode, null, x, y, radius);

    // 캐시된 데이터 확인
    final cachedData = cacheService.get(cacheKey);
    if (cachedData != null) {
      print("🔥 캐시된 데이터 반환 (Category: $categoryGroupCode)");
      return cachedData;
    }

    try {
      // API 호출
      final response = await apiService.fetchPlacesByCategory(categoryGroupCode,
          x: x, y: y, radius: radius);

      // 응답 데이터 캐싱
      cacheService.set(cacheKey, response);
      return response;
    } catch (e) {
      throw Exception("🔴 API 요청 실패: $e");
    }
  }

  /// 캐시 키 생성
  String _generateCacheKey(String keyword, String? categoryGroupCode, String? x,
      String? y, int? radius) {
    return "keyword-$keyword-${categoryGroupCode ?? ''}-${x ?? ''}-${y ?? ''}-${radius ?? ''}";
  }

  // 실시간 장소 목록 리스너
  Stream<List<Place>> listenToPlaces() {
    return firestoreService.listenToPlaces();
  }
}
