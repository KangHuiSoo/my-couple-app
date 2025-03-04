import 'package:firebase_auth/firebase_auth.dart';

class MyUser{
  final String uid;
  final String email;
  final String nickname;
  final String gender;

  MyUser({required this.uid, required this.email, required this.nickname, required this.gender});
}