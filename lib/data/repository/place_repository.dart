import '../datasource/kakao_api_service.dart';
import '../model/place_response.dart';

class PlaceRepository {
  final KakaoApiService apiService;

  PlaceRepository(this.apiService);

  Future<PlaceResponse> getPlaces(String categoryGroupCode, {String? x, String? y, int? radius}) {
    return apiService.fetchPlaces(categoryGroupCode, x: x, y: y, radius: radius);
  }
}