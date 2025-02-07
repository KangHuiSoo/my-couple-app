import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../datasource/kakao_api_service.dart';
import '../../model/place_response.dart';
import '../../repository/place_repository.dart';


final placeProvider = FutureProvider.autoDispose.family<PlaceResponse, String>((ref, categoryGroupCode) async {
  final repository = ref.read(placeRepositoryProvider);
  return repository.getPlaces(categoryGroupCode);
});

final placeRepositoryProvider = Provider<PlaceRepository>((ref) {
  return PlaceRepository(KakaoApiService());
});