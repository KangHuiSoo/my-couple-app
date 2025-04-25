import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'package:my_couple_app/features/auth/model/user.dart';
import 'package:my_couple_app/features/auth/repository/auth_repository.dart';

class AuthState {
  final MyUser? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isLoggedIn;
  final String? profileImageUrl;

  AuthState(
      {this.user,
      this.isLoading = false,
      this.errorMessage,
      this.isLoggedIn = false,
      this.profileImageUrl});

  AuthState copyWith(
      {MyUser? user,
      bool? isLoading,
      String? errorMessage,
      bool? isLoggedIn,
      String? profileImageUrl}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthViewModel(this._repository) : super(AuthState()) {
    _initializeAuthState();
  }

  Future<String> updateProfileImage(File imageFile) async {
    try {
      state = state.copyWith(profileImageUrl: imageFile.path);
      final downloadUrl = await _repository.pickAndUploadImage(imageFile);
      state = state.copyWith(profileImageUrl: downloadUrl);
      return downloadUrl;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      throw e;
    }
  }

  // ✅ 로그인 여부 확인 (앱 시작 시 실행)
  void _initializeAuthState() {
    _repository.authStateChanges().listen((MyUser? user) {
      if (user != null) {
        state = state.copyWith(user: user, isLoggedIn: true);
      } else {
        state = state.copyWith(user: null, isLoggedIn: false);
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.signIn(email, password);
      if (user != null) {
        state =
            state.copyWith(user: user, isLoading: false, errorMessage: null);
      } else {
        state = state.copyWith(
            isLoading: false, errorMessage: "로그인에 실패했습니다.", user: null);
      }
    } catch (e) {
      // Exception의 message만 추출
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      state = state.copyWith(
          isLoading: false, errorMessage: errorMessage, user: null);
    }
  }

  Future<void> signUp(
      String email, String password, String displayName, String gender) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      MyUser? user =
          await _repository.signUp(email, password, displayName, gender);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = AuthState(); // ✅ 로그아웃 시 상태 초기화
  }
}
