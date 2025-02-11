import 'package:flutter_riverpod/flutter_riverpod.dart';

// ✅ 선택된 카테고리 상태 관리
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// ✅ 카테고리 <-> 장소리스트 전환용 - true(카테고리뷰) false(리스트뷰)
final isCategoryViewProvider = StateProvider<bool>((ref) => true);