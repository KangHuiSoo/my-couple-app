import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/place_response.dart';

class KakaoApiService {
  static const String baseUrl = "https://dapi.kakao.com/v2/local/search/";
  final String apiKey;

  KakaoApiService() : apiKey = dotenv.env['KAKAO_API_KEY'] ?? '' {
    if (apiKey.isEmpty) {
      throw Exception("🔴 Kakao API Key가 .env에서 로드되지 않았습니다.");
    }
  }

  /// 공통 HTTP 요청 처리 메서드
  Future<PlaceResponse> _fetchPlaces(String endpoint, Map<String, String?> params) async {
    final uri = Uri.parse(baseUrl + endpoint).replace(queryParameters: params);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'KakaoAK $apiKey',
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return PlaceResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("🔴 API 요청 실패: ${response.statusCode} - ${response.body}");
    }
  }

  /// 키워드로 장소 검색
  Future<PlaceResponse> fetchPlacesByKeyword(String keyword, {String? categoryGroupCode, String? x, String? y, int? radius}) {
    return _fetchPlaces('keyword.json', {
      'query': keyword,
      if (categoryGroupCode != null) 'categoryGroupCode': categoryGroupCode,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (radius != null) 'radius': radius.toString(),
    });
  }

  /// 카테고리별 장소 검색
  Future<PlaceResponse> fetchPlacesByCategory(String categoryGroupCode, {String? x, String? y, int? radius}) {
    return _fetchPlaces('category.json', {
      'category_group_code': categoryGroupCode,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (radius != null) 'radius': radius.toString(),
    });
  }
}