class MyUser{
  final String uid;
  final String email;
  final String nickname;
  final String gender;
  final String? coupleId;

  MyUser({required this.uid, required this.email, required this.nickname, required this.gender, this.coupleId});

  @override
  String toString() {
    return 'MyUser{uid: $uid, email: $email, nickname: $nickname, gender: $gender, coupleId: $coupleId}';
  }
}