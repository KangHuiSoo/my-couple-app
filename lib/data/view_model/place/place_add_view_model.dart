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

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Permissions are denied.');
    }
  }

  Position position = await Geolocator.getCurrentPosition();
  ref.read(currentLocationProvider.notifier).state = LatLng(position.latitude, position.longitude);
  return LatLng(position.latitude, position.longitude);
});

// ✅ 선택한 카테고리 관리
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// ✅ 현재 카테고리 보기 여부
final isCategoryViewProvider = StateProvider<bool>((ref) => true);

final googleMapControllerProvider = StateProvider<GoogleMapController?>((ref) => null);