import 'package:cloud_firestore/cloud_firestore.dart';

/// 사용자 관련 Firestore 작업을 처리하는 서비스 클래스
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 사용자 ID를 기반으로 사용자 정보를 조회합니다
  /// - Firestore의 'users' 컬렉션에서 해당 ID의 문서를 검색
  /// - 문서가 존재하면 데이터를 반환, 없으면 null 반환
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      final docSnapshot =
          await _firestore.collection('users').doc(userId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }
}
