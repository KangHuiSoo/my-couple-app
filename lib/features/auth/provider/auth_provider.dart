import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_couple_app/features/auth/datasource/firebase_auth_service.dart';
import 'package:my_couple_app/features/auth/repository/auth_repository.dart';
import 'package:my_couple_app/features/auth/viewmodel/auth_view_model.dart';


// FirebaseAuthService Provider
final firebaseAuthServiceProvider = Provider((ref) => FirebaseAuthService());

// AuthRepository Provider
final authRepositoryProvider = Provider((ref) {
  final authService = ref.watch(firebaseAuthServiceProvider);
  return AuthRepository(authService);
});

// AuthViewModel Provider
final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthViewModel(repository);
});
