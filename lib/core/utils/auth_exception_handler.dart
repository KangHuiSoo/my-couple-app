import 'package:firebase_auth/firebase_auth.dart';

class AuthExceptionHandler {
  static String generateErrorMessage(FirebaseAuthException exception) {
    print('FirebaseAuthException code: ${exception.code}');
    switch (exception.code) {
      // 공통 오류
      case "invalid-email":
        return "유효하지 않은 이메일 형식입니다.";
      case "user-disabled":
        return "이 계정은 비활성화되었습니다.";
      case "user-not-found":
        return "등록되지 않은 이메일입니다.";
      case "wrong-password":
        return "비밀번호가 잘못되었습니다.";
      case "operation-not-allowed":
        return "이 인증 방식은 현재 사용할 수 없습니다.";

      // 회원가입 관련
      case "email-already-in-use":
        return "이미 사용 중인 이메일입니다.";
      case "weak-password":
        return "비밀번호가 너무 약합니다. 6자 이상 입력하세요.";

      // 자격 증명 로그인 관련
      case "account-exists-with-different-credential":
        return "이미 다른 로그인 방식으로 가입된 이메일입니다. 기존 로그인 방법으로 로그인하세요.";
      case "invalid-credential":
        return "아이디 또는 비밀번호가 잘못되었습니다";

      // 전화 인증 관련
      case "invalid-verification-code":
        return "잘못된 인증 코드입니다. 다시 확인해주세요.";
      case "invalid-verification-id":
        return "인증 ID가 유효하지 않습니다. 다시 시도해주세요.";

      // 재인증 관련
      case "user-mismatch":
        return "현재 로그인된 계정과 자격 증명이 일치하지 않습니다.";

      // 이메일 링크 로그인 관련
      case "expired-action-code":
        return "이메일 링크가 만료되었습니다. 새 링크를 요청해주세요.";

      default:
        return "알 수 없는 오류가 발생했습니다. 다시 시도해주세요.";
    }
  }
}


// class AuthExceptionHandler {
//   static String generateErrorMessage(FirebaseAuthException exception) {
//     print(exception.code);
//     switch (exception.code) {
//       case "invalid-email":
//         return "유효하지 않은 이메일 형식입니다.";
//       case "user-disabled":
//         return "이 계정은 비활성화되었습니다.";
//       case "user-not-found":
//         return "등록되지 않은 이메일입니다.";
//       case "wrong-password":
//         return "비밀번호가 잘못되었습니다.";
//       case "email-already-in-use":
//         return "이미 사용 중인 이메일입니다.";
//       case "operation-not-allowed":
//         return "이 인증 방식은 현재 사용할 수 없습니다.";
//       case "weak-password":
//         return "비밀번호가 너무 약합니다. 6자 이상 입력하세요.";
//       default:
//         return "알 수 없는 오류가 발생했습니다. 다시 시도해주세요.";
//     }
//   }
// }