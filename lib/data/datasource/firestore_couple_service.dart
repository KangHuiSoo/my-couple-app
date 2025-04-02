import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_couple_app/data/model/couple/couple.dart';

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
    final doc = await _firestore.collection('users').doc(userId).get();
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
    await _firestore.collection('couples').doc(coupleId).update({
      'user2Id': userId,
      'coupleId': coupleId
    });

    // 사용자 문서 업데이트
    await _firestore.collection('users').doc(userId).update({
      'coupleId': coupleId,
    });
  }

  // 사용자의 커플 정보 조회
  Future<Couple?> getUserCouple(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final coupleId = userDoc.data()?['coupleId'];

    if (coupleId == null) return null;

    final coupleDoc =
        await _firestore.collection('couples').doc(coupleId).get();
    return Couple.fromFirestore(coupleDoc);
  }
}
