import 'package:my_couple_app/core/utils/logging_util.dart';

import '../datasource/kakao_api_service.dart';
import '../model/place_response.dart';

class PlaceRepository {
  final KakaoApiService apiService;
  final Map<String, PlaceResponse> _cache = {}; // 메모리 캐싱
  final Map<String, DateTime> _cacheTimestamp = {}; // 캐시 시간 기록

  PlaceRepository(this.apiService);

  static const Duration cacheDuration = Duration(minutes: 10); // 10분 캐싱 유지

  Future<PlaceResponse> getPlacesByKeyword(String keyword, {String? categoryGroupCode, String? x, String? y, int? radius}) async{
    String cacheKey = "keyword-$keyword-${categoryGroupCode ?? ''}-${x ?? ''}-${y ?? ''}-${radius ?? ''}";

    // 캐싱된 데이터가 있고, 10분 이내에 가져온 데이터라면 API요청 없이 반환
    if(_cache.containsKey(cacheKey) && DateTime.now().difference(_cacheTimestamp[cacheKey]!) < cacheDuration) {
      print("🔥 캐싱된 데이터 반환 (Keyword: $keyword)");
      return _cache[cacheKey]!;
    }
    
    try{
      PlaceResponse response = await apiService.fetchPlacesByKeyword(keyword, categoryGroupCode: categoryGroupCode, x: x, y: y, radius: radius);
      _cache[cacheKey] = response; // 데이터 캐싱
      _cacheTimestamp[cacheKey] = DateTime.now();
      printFullResponse(response);
      return response;
    } catch(e) {
      throw Exception("🔴 API 요청 실패: $e");
    }
  }

  Future<PlaceResponse> getPlacesByCategory(String categoryGroupCode, {String? x, String? y, int? radius = 3000}) async{
    String cacheKey = "categoryGroupCode-$categoryGroupCode-${x ?? ''}-${y ?? y}-${radius ?? ''}";

    if(_cache.containsKey(cacheKey) && DateTime.now().difference(_cacheTimestamp[cacheKey]!) < cacheDuration) {
      print("🔥 캐싱된 데이터 반환 (categoryGroupCode: $categoryGroupCode)");
      return _cache[cacheKey]!;
    }

    try{
      PlaceResponse response = await apiService.fetchPlacesByCategory(categoryGroupCode, x: x, y: y, radius: radius);
      _cache[cacheKey] = response;
      _cacheTimestamp[cacheKey] = DateTime.now();
      printFullResponse(response);
      return response;
    }catch(e){
      throw Exception("🔴 API 요청 실패: $e");
    }
  }
}





// import 'package:my_couple_app/core/utils/logging_util.dart';
//
// import '../datasource/kakao_api_service.dart';
// import '../model/place_response.dart';
//
// class PlaceRepository {
//   final KakaoApiService apiService;
//
//   PlaceRepository(this.apiService);
//
//   Future<PlaceResponse> getPlacesByKeyword(String keyword, {String? categoryGroupCode, String? x, String? y, int? radius}) async{
//     Future<PlaceResponse> placeResponseResult= apiService.fetchPlacesByKeyword(keyword, categoryGroupCode:categoryGroupCode, x: x, y: y, radius: radius);
//     PlaceResponse response = await placeResponseResult;
//     // print("✅ API 응답 데이터: $response");
//     printFullResponse(response);
//     return placeResponseResult;
//   }
//
//   Future<PlaceResponse> getPlacesByCategory(String categoryGroupCode, {String? x, String? y, int? radius = 3000}) async{
//     Future<PlaceResponse> placeResponseResult= apiService.fetchPlacesByCategory(categoryGroupCode, x: x, y: y, radius: radius);
//     PlaceResponse response = await placeResponseResult;
//     // print("✅ API 응답 데이터: $response");
//     printFullResponse(response);
//     return placeResponseResult;
//   }
// }