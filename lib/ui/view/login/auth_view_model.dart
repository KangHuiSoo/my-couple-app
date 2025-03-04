import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_couple_app/data/repository/auth_repository.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;

  AuthState({this.user, this.isLoading = false, this.errorMessage});

  AuthState copyWith({User? user, bool? isLoading, String? errorMessage}) {
    return AuthState(
        user : user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthViewModel(this._repository) : super(AuthState());

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      User? user = await _repository.signIn(email, password);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> signUp(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      User? user = await _repository.signUp(email, password);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  // Future<void> signOut() async {
  //   try {
  //     await _repository.signOut();
  //     state = AuthState(); // 초기 상태로 리셋
  //   } catch (e) {
  //     state = state.copyWith(errorMessage: e.toString());
  //   }
  // }
}