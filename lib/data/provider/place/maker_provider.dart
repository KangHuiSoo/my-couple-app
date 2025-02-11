import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// 📌 Google Map의 마커를 저장하는 Provider
final markersProvider = StateProvider<Set<Marker>>((ref) {
  return {};
});