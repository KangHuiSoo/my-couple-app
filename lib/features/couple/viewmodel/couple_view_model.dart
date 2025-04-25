import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_couple_app/features/couple/datasource/firestore_couple_service.dart';
import 'package:my_couple_app/features/couple/model/couple.dart';

import 'package:my_couple_app/features/couple/repository/couple_repository.dart';
import 'package:my_couple_app/features/auth/provider/auth_provider.dart';
import 'package:my_couple_app/features/auth/model/user.dart';

/// 커플 관련 비즈니스 로직을 처리하는 ViewModel
/// - StateNotifier를 상속하여 상태 관리
/// - CoupleRepository를 통해 Firestore와 통신
class CoupleViewModel extends StateNotifier<AsyncValue<Couple?>> {
  final CoupleRepository _repository;

  CoupleViewModel(this._repository) : super(const AsyncValue.data(null));

  // 커플 상대방 정보
  AsyncValue<MyUser?> _partner = const AsyncValue.data(null);
  AsyncValue<MyUser?> get partner => _partner;

  /// 사용자 ID를 기반으로 커플 파트너 정보를 로드합니다
  /// 1. 로딩 상태 설정
  /// 2. Repository를 통해 파트너 정보 조회
  /// 3. 상태 업데이트
  Future<void> loadCouplePartner(String userId) async {
    try {
      _partner = const AsyncValue.loading();
      state = const AsyncValue.loading();

      // 파트너 정보만 조회 (커플 정보는 파트너 정보에 포함되어 있음)
      final partner = await _repository.getCouplePartner(userId);

      if (partner != null && partner.coupleId != null) {
        _partner = AsyncValue.data(partner);
        // 파트너 정보에서 커플 정보를 가져와서 상태 업데이트
        state = AsyncValue.data(Couple(
          id: partner.coupleId!,
          code: '', // 코드는 필요하지 않으므로 빈 문자열로 설정
          user1Id: userId,
          createdAt: DateTime.now(), // 정확한 시간은 필요하지 않으므로 현재 시간으로 설정
        ));
      } else {
        _partner = const AsyncValue.data(null);
        state = const AsyncValue.data(null);
      }

      print('CoupleViewModel - Partner loaded: $partner');
    } catch (e, stack) {
      _partner = AsyncValue.error(e, stack);
      state = AsyncValue.error(e, stack);
      print('CoupleViewModel - Error loading partner: $e');
    }
  }

  /// 현재 로그인한 사용자의 ID를 가져옴
  String _getCurrentUserId(WidgetRef ref) {
    final authState = ref.read(authViewModelProvider);
    if (authState.user == null) {
      throw Exception('로그인이 필요합니다.');
    }
    return authState.user!.uid;
  }

  /// 커플 코드 생성
  /// 1. 현재 사용자가 이미 커플인지 확인
  /// 2. 새로운 커플 코드 생성
  /// 3. 생성된 커플 정보 반환
  Future<Couple> createCoupleCode(WidgetRef ref) async {
    try {
      state = const AsyncValue.loading();
      final userId = _getCurrentUserId(ref);

      // 이미 커플인지 확인
      if (await _repository.hasCouple(userId)) {
        throw Exception('이미 커플로 연결되어 있습니다.');
      }

      final couple = await _repository.createCoupleCode(userId);
      state = AsyncValue.data(couple);
      return couple;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// 코드로 커플 찾기
  /// - 입력된 코드로 커플 정보 조회
  Future<Couple?> findCoupleByCode(String code) async {
    try {
      return await _repository.findCoupleByCode(code);
    } catch (e) {
      rethrow;
    }
  }

  /// 커플 연결
  /// 1. 현재 사용자가 이미 커플인지 확인
  /// 2. 입력된 커플 ID로 커플 연결
  /// 3. 연결된 커플 정보 로드
  Future<void> joinCouple(String coupleId, WidgetRef ref) async {
    try {
      state = const AsyncValue.loading();
      final userId = _getCurrentUserId(ref);

      // 이미 커플인지 확인
      if (await _repository.hasCouple(userId)) {
        throw Exception('이미 다른 사람과 연결되어 있어요.');
      }

      await _repository.joinCouple(coupleId, userId);
      final couple = await _repository.getUserCouple(userId);
      state = AsyncValue.data(couple);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// 사용자의 커플 정보 조회
  Future<void> loadUserCouple(WidgetRef ref) async {
    try {
      state = const AsyncValue.loading();
      final userId = _getCurrentUserId(ref);
      final couple = await _repository.getUserCouple(userId);
      state = AsyncValue.data(couple);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// CoupleViewModel을 제공하는 Provider
/// Riverpod을 사용하여 상태 관리를 구현
final coupleRepositoryProvider = Provider((ref) => CoupleRepository(
      FirestoreCoupleService(),
    ));

final coupleViewModelProvider =
    StateNotifierProvider<CoupleViewModel, AsyncValue<Couple?>>((ref) {
  return CoupleViewModel(ref.watch(coupleRepositoryProvider));
});
