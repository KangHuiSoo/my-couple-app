import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../datasource/firestore_place_service.dart';
import '../../datasource/kakao_api_service.dart';
import '../../repository/place_repository.dart';

final placeRepositoryProvider = Provider<PlaceRepository>((ref) {
  return PlaceRepository(KakaoApiService(), FirestorePlaceService());
});
