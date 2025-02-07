import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/place_response.dart';

class KakaoApiService {
  static const String baseUrl = "https://dapi.kakao.com/v2/local/search/category.json";

  KakaoApiService();

  Future<PlaceResponse> fetchPlaces(String categoryGroupCode, {String? x, String? y, int? radius}) async {
    await dotenv.load(fileName: 'assets/config/.env');
    String? apiKey = dotenv.env['KAKAO_API_KEY'];

    final response = await http.get(
      Uri.parse('$baseUrl?category_group_code=$categoryGroupCode${x != null ? '&x=$x' : ''}${y != null ? '&y=$y' : ''}${radius != null ? '&radius=$radius' : ''}'),
      headers: {
        'Authorization': 'KakaoAK $apiKey',
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return PlaceResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load places');
    }
  }
}