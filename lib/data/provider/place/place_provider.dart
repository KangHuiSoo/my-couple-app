import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/place/place.dart';

//마커가 선택된 장소
final selectedPlaceProvider = StateProvider<Place?>((ref) => null);

//캘린더에서 선택한 날짜
final selectedDateProvider = StateProvider<String?>((ref) => null);
