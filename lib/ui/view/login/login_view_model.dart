import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginViewModel extends StateNotifier{
  LoginViewModel(super.state);

  // final loginProvider = StateNotifierProvider<UserProvider>

  void signUp(String email, String password){
    try{
      //TODO : firebase 로그인 기능 구현
    }catch(e){
      //TODO : 에외 핸들링 처리
    }
  }

  void signIn(String email, String password){
    try{
      //TODO : firebase 가입 기능 구현
    }catch(e){
      //TODO : 에외 핸들링 처리
    }
  }

  void logout(){
    //TODO: 로그아웃 기능 구현
  }

  void findId(){}
  void findPw(){}

}