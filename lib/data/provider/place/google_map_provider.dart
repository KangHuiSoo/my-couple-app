import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// 맵컨트롤러 상태관리
final googleMapControllerProvider = StateProvider<GoogleMapController?>((ref) => null);