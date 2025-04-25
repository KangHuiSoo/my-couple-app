import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/map_util.dart';
import '../datasource/kakao_api_service.dart';
import '../model/place_response.dart';
import '../repository/place_repository.dart';
import '../model/place.dart';
import '../datasource/firestore_place_service.dart';
import '../../../core/services/cache_service.dart';

class PlaceViewModel extends StateNotifier<AsyncValue<PlaceResponse?>> {
  final PlaceRepository repository;
  List<Place> _places = [];
  StreamSubscription<List<Place>>? _placesSubscription;

  PlaceViewModel(this.repository) : super(const AsyncValue.loading()) {
    // 실시간 리스너 설정
    _setupPlacesListener();
  }

  // 현재 장소 목록 반환
  List<Place> get places => _places;

  // 실시간 리스너 설정 ( 장소 목록 실시간 업데이트)
  void _setupPlacesListener() {
    _placesSubscription?.cancel(); // 기존 리스너가 있다면 취소
    _placesSubscription = repository.listenToPlaces().listen(
      (places) {
        _places = places;
      },
      onError: (error) {
        print("장소 목록 실시간 업데이트 실패: $error");
      },
    );
  }

  // 선택한 장소 firestore에 추가
  Future<void> addPlace(Place place) async {
    try {
      await repository.addPlace(place);
      // 실시간 리스너가 자동으로 목록을 업데이트하므로 별도의 로드가 필요 없음
    } catch (e) {
      throw Exception("장소 추가 실패: $e");
    }
  }

  @override
  void dispose() {
    _placesSubscription?.cancel(); // 리스너 정리
    super.dispose();
  }


  /* 검색 키워드로 장소 검색 */
  Future<void> fetchPlacesByKeyword(String keyword,
      {String? categoryGroupCode, String? x, String? y, int? radius}) async {
    state = const AsyncValue.loading();
    try {
      final result = await repository.getPlacesByKeyword(keyword,
          categoryGroupCode: categoryGroupCode, x: x, y: y, radius: radius);
      state = AsyncValue.data(result);
    } catch (e, stackTrace) {
      state = AsyncValue.error("🔴 장소 검색 실패: $e", stackTrace);
    }
  }

  /* 카테고리별 장소 주변 장소 검색*/
  Future<void> fetchPlacesByCategory(WidgetRef ref, String categoryGroupCode,
      {String? x, String? y, int? radius}) async {
    state = const AsyncValue.loading();
    try {
      final result = await repository.getPlacesByCategory(categoryGroupCode,
          x: x, y: y, radius: radius);

      state = AsyncValue.data(result);
      if (result != null) {
        addSearchMarkers(ref, result.places);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final placeRepositoryProvider = Provider((ref) => PlaceRepository(
      KakaoApiService(),
      FirestorePlaceService(),
      CacheService<PlaceResponse>(),
    ));
final placeNotifierProvider =
    StateNotifierProvider<PlaceViewModel, AsyncValue<PlaceResponse?>>(
  (ref) => PlaceViewModel(ref.watch(placeRepositoryProvider)),
);
