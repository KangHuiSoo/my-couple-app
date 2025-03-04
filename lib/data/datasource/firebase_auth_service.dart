import 'package:firebase_auth/firebase_auth.dart';
import '../../core/utils/auth_exception_handler.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 로그인
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(AuthExceptionHandler.generateErrorMessage(e));
    }
  }

  // 회원가입
  Future<User?> signUp(String email, String password, String displayName) async {
    print('서비스 3');
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(displayName); // 🔥 displayName 설정
        await user.reload(); // 🔥 변경된 정보 반영
        user = _auth.currentUser; // 🔥 업데이트된 유저 정보 가져오기
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(AuthExceptionHandler.generateErrorMessage(e));
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("로그아웃 중 오류가 발생했습니다.");
    }
  }

  // 현재 로그인한 사용자 가져오기
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}