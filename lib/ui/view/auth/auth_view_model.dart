import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_couple_app/data/model/auth/user.dart';
import 'package:my_couple_app/data/repository/auth_repository.dart';

class AuthState {
  final MyUser? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isLoggedIn;

  AuthState({this.user, this.isLoading = false, this.errorMessage, this.isLoggedIn = false});

  AuthState copyWith({MyUser? user, bool? isLoading, String? errorMessage, bool? isLoggedIn}) {
    return AuthState(
        user : user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthViewModel(this._repository) : super(AuthState()) {
    _checkAuthStatus();
  }


  Future<void>? pickAndUploadImage (){
    _repository.pickAndUploadImage();
  }

  // ✅ 로그인 여부 확인 (앱 시작 시 실행)
  void _checkAuthStatus() {
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
      MyUser? user = await _repository.signIn(email, password);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> signUp(String email, String password, String displayName, String gender) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      MyUser? user = await _repository.signUp(email, password, displayName, gender);
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