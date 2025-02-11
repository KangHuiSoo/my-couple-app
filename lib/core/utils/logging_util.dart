import 'package:flutter/foundation.dart'; // debugPrint() 사용을 위해 필요

// 📌 API 응답 데이터를 보기 쉽게 출력하는 유틸리티 함수
void printFullResponse(dynamic response) {
  debugPrint("✅ API 응답 데이터:\n${response.toString()}", wrapWidth: 1024);
}