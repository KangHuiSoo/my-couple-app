import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_couple_app/features/auth/provider/auth_provider.dart';
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
  final String? coupleId;

  PlaceViewModel(this.repository, this.coupleId) : super(const AsyncValue.loading()) {
    // 실시간 리스너 설정
    _setupPlacesListener();
  }

  // 현재 장소 목록 반환
  List<Place> get places => _places;

  // 실시간 리스너 설정 ( 장소 목록 실시간 업데이트)
  void _setupPlacesListener() {
    _placesSubscription?.cancel(); // 기존 리스너가 있다면 취소
    _placesSubscription = repository.listenToPlaces(coupleId).listen(
      (places) {
        _places = places;

        // ✅ 중요한 부분: 상태를 업데이트해서 UI가 리렌더링되도록 함
        state = AsyncValue.data(state.value);
        // 이 줄이 핵심! state 자체는 PlaceResponse?지만 그냥 value 재할당 하면 트리거 발생함
      },
      onError: (error, stack) {
        state = AsyncValue.error(error, stack);
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

  // TODO : 장소에 대한 평가 점수 저장 2025.05.07 13:46
  Future<void> updateUserRating(String placeId, String userId, int rating) async {
    try {
      await repository.updateUserRating(placeId, userId, rating);
      state = AsyncValue.data(state.value);
    } catch (e, stack) {
      print('🔴 별점 저장 실패: $e');
      state = AsyncValue.error('별점 저장 실패', stack);
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
  (ref) {
    final repository = ref.watch(placeRepositoryProvider);
    final authState = ref.watch(authViewModelProvider);
    final coupleId = authState.user?.coupleId;

    if(coupleId == null) {
      print("커플 연결 안됨. 연결필요");
      // throw Exception("coupleId가 존재하지 않습니다. 로그인이 필요합니다.");
    }

    return PlaceViewModel(repository, coupleId);
  } ,
);
