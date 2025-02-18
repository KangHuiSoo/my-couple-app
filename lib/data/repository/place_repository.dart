import 'package:my_couple_app/core/utils/logging_util.dart';

import '../datasource/kakao_api_service.dart';
import '../model/place_response.dart';

class PlaceRepository {
  final KakaoApiService apiService;

  PlaceRepository(this.apiService);

  Future<PlaceResponse> getPlacesByKeyword(String keyword, {String? categoryGroupCode, String? x, String? y, int? radius}) async{
    Future<PlaceResponse> placeResponseResult= apiService.fetchPlacesByKeyword(keyword, categoryGroupCode:categoryGroupCode, x: x, y: y, radius: radius);
    PlaceResponse response = await placeResponseResult;
    // print("✅ API 응답 데이터: $response");
    printFullResponse(response);
    return placeResponseResult;
  }

  Future<PlaceResponse> getPlacesByCategory(String categoryGroupCode, {String? x, String? y, int? radius = 3000}) async{
    Future<PlaceResponse> placeResponseResult= apiService.fetchPlacesByCategory(categoryGroupCode, x: x, y: y, radius: radius);
    PlaceResponse response = await placeResponseResult;
    // print("✅ API 응답 데이터: $response");
    printFullResponse(response);
    return placeResponseResult;
  }
}