import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_couple_app/data/datasource/firebase_auth_service.dart';
import 'package:my_couple_app/data/model/auth/user.dart';

class AuthRepository {
  final FirebaseAuthService _firebaseAuthService;

  AuthRepository(this._firebaseAuthService);

  Stream<MyUser?> authStateChanges(){
    return _firebaseAuthService.authStateChanges();
  }

  Future<MyUser?> signIn(String email, String password){
    return _firebaseAuthService.signIn(email, password);
  }

  Future<MyUser?> signUp(String email, String password, String displayName, String gender){
    return _firebaseAuthService.signUp(email, password, displayName, gender);
  }


  Future<void> signOut() {
    return _firebaseAuthService.signOut();
  }
}