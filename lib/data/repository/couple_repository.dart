import 'package:my_couple_app/data/datasource/firestore_couple_service.dart';
import 'package:my_couple_app/data/model/couple/couple.dart';

class CoupleRepository {
  final FirestoreCoupleService _coupleService;

  CoupleRepository(this._coupleService);

  // 커플 코드 생성
  Future<Couple> createCoupleCode(String userId) async {
    return await _coupleService.createCoupleCode(userId);
  }

  // 코드로 커플 찾기
  Future<Couple?> findCoupleByCode(String code) async {
    return await _coupleService.findCoupleByCode(code);
  }

  // 커플 연결
  Future<void> joinCouple(String coupleId, String userId) async {
    await _coupleService.joinCouple(coupleId, userId);
  }

  // 사용자의 커플 상태 확인
  Future<bool> hasCouple(String userId) async {
    return await _coupleService.hasCouple(userId);
  }

  // 사용자의 커플 정보 조회
  Future<Couple?> getUserCouple(String userId) async {
    return await _coupleService.getUserCouple(userId);
  }
}
