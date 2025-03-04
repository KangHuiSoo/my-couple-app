import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_couple_app/data/datasource/firebase_auth_service.dart';

class AuthRepository {
  final FirebaseAuthService _firebaseAuthService;

  AuthRepository(this._firebaseAuthService);

  Future<User?> signUp(String email, String password){
    return _firebaseAuthService.signUp(email, password);
  }

  Future<User?> signIn(String email, String password){
    return _firebaseAuthService.signIn(email, password);
  }
}