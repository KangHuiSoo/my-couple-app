import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_couple_app/features/place/provider/place_provider.dart';

import '../../features/place/model/place.dart';

// 📌 현재 위치 마커 추가
void setCurrentLocationMarker(WidgetRef ref, LatLng currentPosition) {}

// 📌 검색된 장소 마커 추가
void addSearchMarkers(WidgetRef ref, List<Place> places) {
  final markers = ref.read(markersProvider.notifier);

  // ✅ 기존 현재 위치 마커 유지
  final currentMarkers =
      markers.state.where((m) => m.markerId.value == "current").toSet();

  // 📌 API에서 받아온 데이터를 기반으로 검색 마커 생성
  final newMarkers = places.map((place) {
    return Marker(
      onTap: (){
        ref.read(selectedPlaceProvider.notifier).state = place;
      },
      markerId: MarkerId(place.id),
      position: LatLng(
          double.parse(place.y), double.parse(place.x)), // ✅ 위도(y), 경도(x) 사용
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue), // ✅ 검색 마커 색상 변경
      infoWindow: InfoWindow(
        title: place.placeName,
        snippet: place.addressName,
      ),
    );
  }).toSet();

  // ✅ 기존 현재 위치 마커 + 새로운 검색된 마커들 추가
  markers.state = {...currentMarkers, ...newMarkers};
}
