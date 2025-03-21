import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_couple_app/data/model/auth/user.dart';
import '../../core/utils/auth_exception_handler.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();


  //프로필 사진 업데이트
  Future<void> pickAndUploadImage() async{
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    User? user = _auth.currentUser;
    print('1. user ======');
    print(user);

    File file = File(pickedFile.path);
    Reference ref = _storage.ref().child('profile_images/${user!.uid}.jpg');
    UploadTask uploadTask = ref.putFile(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    await user.updatePhotoURL(downloadUrl);

    print('2. user ======');
    print(user);
  }

  // 로그인
  Future<MyUser?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = userCredential.user;
      if(firebaseUser == null) return null;

      DocumentSnapshot doc = await _firestore.collection('user').doc(firebaseUser.uid).get();
      if(!doc.exists) {
        throw Exception("Firestore에 사용자 정보가 없습니다.");
      }

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return MyUser(uid: data['uid'], email: data['email'], nickname: data['nickname'], gender: data['gender']);
    } on FirebaseAuthException catch (e) {
      throw Exception(AuthExceptionHandler.generateErrorMessage(e));
    }
  }

  // 회원가입
  Future<MyUser?> signUp(String email, String password, String displayName, String gender) async {
    print('서비스 3');
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = userCredential.user;
      if(firebaseUser != null) {
        await firebaseUser.updateDisplayName(displayName);
        await firebaseUser.reload();

        //TODO: Firestore 저장 로직 구현
        await _firestore.collection('user').doc(firebaseUser.uid).set({
          'uid' : firebaseUser.uid,
          'email': firebaseUser.email ?? '',
          'nickname': displayName,
          'gender': gender
        });
      }

      return MyUser(
          uid: firebaseUser!.uid,
          email: firebaseUser.email ?? '',
          nickname: displayName,
          gender: gender
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(AuthExceptionHandler.generateErrorMessage(e));
    }
  }

  // 🔥 Firestore에서 현재 로그인된 유저 정보 가져오기
  Future<MyUser?> getCurrentUser() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    DocumentSnapshot doc = await _firestore.collection('user').doc(firebaseUser.uid).get();
    if (!doc.exists) return null;

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MyUser(
      uid: data['uid'],
      email: data['email'],
      nickname: data['nickname'],
      gender: data['gender'],
    );
  }

  // 🔥 Firebase 인증 상태 변경 감지 → `MyUser` 변환하여 반환
  Stream<MyUser?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((User? firebaseUser) async {
      if (firebaseUser == null) return null;
      return await getCurrentUser();
    });
  }

  // 로그아웃
  Future<void> signOut() async {
    await _auth.signOut();
  }
}