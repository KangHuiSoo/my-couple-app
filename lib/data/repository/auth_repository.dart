import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_couple_app/data/datasource/firebase_auth_service.dart';

class AuthRepository {
  final FirebaseAuthService _firebaseAuthService;

  AuthRepository(this._firebaseAuthService);

  Future<User?> signIn(String email, String password){
    return _firebaseAuthService.signIn(email, password);
  }

  Future<User?> signUp(String email, String password, String displayName){
    print('리포지토리2');
    return _firebaseAuthService.signUp(email, password, displayName);
  }
}