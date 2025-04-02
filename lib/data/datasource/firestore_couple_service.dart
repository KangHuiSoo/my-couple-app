import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_couple_app/data/model/couple/couple.dart';
import 'package:my_couple_app/data/model/auth/user.dart';

class FirestoreCoupleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

  // 랜덤 코드 생성 (6자리)
  String _generateCode() {
    return List.generate(6, (index) => _chars[Random().nextInt(_chars.length)])
        .join();
  }

  // 사용자의 커플 상태 확인
  Future<bool> hasCouple(String userId) async {
    final doc = await _firestore.collection('user').doc(userId).get();
    return doc.data()?['coupleId'] != null;
  }

  // 커플 코드 생성
  Future<Couple> createCoupleCode(String userId) async {
    // 이미 커플인지 확인
    if (await hasCouple(userId)) {
      throw Exception('이미 커플로 연결되어 있습니다.');
    }

    // 새로운 코드 생성
    String code;
    bool isUnique = false;
    do {
      code = _generateCode();
      final existing = await _firestore
          .collection('couples')
          .where('code', isEqualTo: code)
          .get();
      isUnique = existing.docs.isEmpty;
    } while (!isUnique);

    // 커플 문서 생성
    final docRef = await _firestore.collection('couples').add({
      'code': code,
      'user1Id': userId,
      'user2Id': null,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 사용자 문서 업데이트
    await _firestore.collection('user').doc(userId).update({
      'coupleId': docRef.id,
    });

    return Couple(
      id: docRef.id,
      code: code,
      user1Id: userId,
      createdAt: DateTime.now(),
    );
  }

  // 코드로 커플 찾기
  Future<Couple?> findCoupleByCode(String code) async {
    final querySnapshot = await _firestore
        .collection('couples')
        .where('code', isEqualTo: code)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    final doc = querySnapshot.docs.first;
    final couple = Couple.fromFirestore(doc);

    // 이미 연결된 코드인지 확인
    if (couple.isConnected) {
      throw Exception('이 코드는 이미 사용되었습니다.');
    }

    return couple;
  }

  // 커플 연결
  Future<void> joinCouple(String coupleId, String userId) async {
    // 이미 커플인지 확인
    if (await hasCouple(userId)) {
      throw Exception('이미 다른 사람과 연결되어 있어요.');
    }

    // 커플 문서 업데이트
    await _firestore
        .collection('couples')
        .doc(coupleId)
        .update({'user2Id': userId});

    // 사용자 문서 업데이트
    await _firestore.collection('user').doc(userId).update({
      'coupleId': coupleId,
    });
  }

  // 사용자의 커플 정보 조회 (최적화된 버전)
  Future<Couple?> getUserCouple(String userId) async {
    try {
      final userDoc = await _firestore.collection('user').doc(userId).get();
      final userData = userDoc.data();
      if (userData == null) return null;

      final coupleId = userData['coupleId'] as String?;
      if (coupleId == null) return null;

      final coupleDoc =
          await _firestore.collection('couples').doc(coupleId).get();
      return Couple.fromFirestore(coupleDoc);
    } catch (e) {
      print('Error getting user couple: $e');
      return null;
    }
  }

  // 커플 상대방 정보 가져오기
  Future<MyUser?> getCouplePartner(String userId) async {
    try {
      print('Getting couple partner for user: $userId');

      // 사용자와 커플 정보를 한 번에 가져오기
      final userDoc = await _firestore.collection('user').doc(userId).get();
      final userData = userDoc.data();
      if (userData == null) {
        print('User data is null');
        return null;
      }

      final coupleId = userData['coupleId'] as String?;
      if (coupleId == null) {
        print('CoupleId is null');
        return null;
      }

      // 커플 정보 가져오기
      final coupleDoc =
          await _firestore.collection('couples').doc(coupleId).get();
      final coupleData = coupleDoc.data();
      if (coupleData == null) {
        print('Couple data is null');
        return null;
      }

      // user2Id가 null이면 아직 연결되지 않은 상태
      if (coupleData['user2Id'] == null) {
        print('Partner not connected yet (user2Id is null)');
        return null;
      }

      final partnerId = coupleData['user1Id'] == userId
          ? coupleData['user2Id'] as String
          : coupleData['user1Id'] as String;

      // 파트너 정보 가져오기
      final partnerDoc =
          await _firestore.collection('user').doc(partnerId).get();
      final partnerData = partnerDoc.data();
      if (partnerData == null) {
        print('Partner data is null');
        return null;
      }

      return MyUser(
        uid: partnerId,
        email: partnerData['email'] as String,
        nickname: partnerData['nickname'] as String,
        gender: partnerData['gender'] as String,
        coupleId: coupleId,
        profileImageUrl: partnerData['profileImageUrl'] as String?,
      );
    } catch (e, stackTrace) {
      print('Error getting couple partner: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }
}
