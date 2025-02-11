import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

// 📍 현재 위치를 관리하는 StateProvider
final currentLocationProvider = StateProvider<LatLng>((ref) => LatLng(37.5665, 126.9780));

// 📍 위치 업데이트 비동기 함수
final locationUpdateProvider = FutureProvider.autoDispose((ref) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  // 위치 권한 요청 로직
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Permissions are denied.');
    }

    // TODO: 사용자가 권한을 거부한경우 셋팅창 오픈 로직  openAppSettings() 함수 사용할것
  }
  //

  //현재위치의 위도와 경도를 가져와 상태변경
  Position position = await Geolocator.getCurrentPosition();
  ref.read(currentLocationProvider.notifier).state = LatLng(position.latitude, position.longitude);
  return LatLng(position.latitude, position.longitude);
  //
});

// ✅ 선택된 카테고리 상태 관리
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// ✅ 카테고리 <-> 장소리스트 전환용 - true(카테고리뷰) false(리스트뷰)
final isCategoryViewProvider = StateProvider<bool>((ref) => true);


// 맵컨트롤러 상태관리
final googleMapControllerProvider = StateProvider<GoogleMapController?>((ref) => null);