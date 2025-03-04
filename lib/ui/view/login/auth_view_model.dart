import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_couple_app/data/repository/auth_repository.dart';

enum Status { uninitialized, authenticated, authenticating, unauthenticated }

class LoginViewModel extends StateNotifier{
  final FirebaseAuth _auth;
  Status _status;
  User? _user;

  LoginViewModel(super._state)
      : _auth = FirebaseAuth.instance,
        _user = FirebaseAuth.instance.currentUser,
        _status = FirebaseAuth.instance.currentUser != null
            ? Status.authenticated
            : Status.unauthenticated {
    _auth.authStateChanges().listen(_onStateChanged);
  }

  // final loginProvider = StateNotifierProvider<UserProvider>
  void signUp(String email, String password){
    try{
      //TODO : repository 호출
      AuthRepository.login(email, password);
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

  Future<void> _onStateChanged(User? user) async {
    if (user == null) {
      _status = Status.unauthenticated;
    } else {
      _status = Status.authenticated;
      _user = user; // Add this line
    }
  }
}