import 'package:firebase_auth/firebase_auth.dart';

class AuthExceptionHandler {
  static String generateErrorMessage(FirebaseAuthException exception) {
    print(exception.code);
    switch (exception.code) {
      case "invalid-email":
        return "유효하지 않은 이메일 형식입니다.";
      case "user-disabled":
        return "이 계정은 비활성화되었습니다.";
      case "user-not-found":
        return "등록되지 않은 이메일입니다.";
      case "wrong-password":
        return "비밀번호가 잘못되었습니다.";
      case "email-already-in-use":
        return "이미 사용 중인 이메일입니다.";
      case "operation-not-allowed":
        return "이 인증 방식은 현재 사용할 수 없습니다.";
      case "weak-password":
        return "비밀번호가 너무 약합니다. 6자 이상 입력하세요.";
      default:
        return "알 수 없는 오류가 발생했습니다. 다시 시도해주세요.";
    }
  }
}