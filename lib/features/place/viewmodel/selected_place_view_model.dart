import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedPlaceIdsNotifier extends StateNotifier<Set<String>> {
  SelectedPlaceIdsNotifier() : super({});

  //체크박스 토글
  void toggle(String placeId) {
    if (state.contains(placeId)) {
      state = {...state}..remove(placeId);
    } else {
      state = {...state, placeId};
    }
  }

  // 전체 초기화
  void clear() {
    state = {};
  }

  //체크 여부
  bool isSelected(String placeId) {
    return state.contains(placeId);
  }
}

