import 'package:cloud_firestore/cloud_firestore.dart';

/// 커플 관련 Firestore 작업을 처리하는 서비스 클래스
class CoupleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 사용자 ID를 기반으로 커플 정보를 조회합니다
  /// - Firestore의 'couples' 컬렉션에서 userId가 일치하는 문서를 검색
  /// - 결과가 있으면 문서 데이터를 반환, 없으면 null 반환
  Future<Map<String, dynamic>?> getCoupleByUserId(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('couples')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }
      return null;
    } catch (e) {
      print('Error getting couple: $e');
      return null;
    }
  }
}
