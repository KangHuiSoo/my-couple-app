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
  Future<void> pickAndUploadImage() async {
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
      if (firebaseUser == null) return null;

      DocumentSnapshot doc =
          await _firestore.collection('user').doc(firebaseUser.uid).get();
      if (!doc.exists) {
        await _auth.signOut(); // Firestore에 데이터가 없으면 로그아웃
        throw Exception("사용자 정보를 찾을 수 없습니다.");
      }

      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        await _auth.signOut();
        throw Exception("사용자 데이터가 올바르지 않습니다.");
      }

      return MyUser(
          uid: data['uid'] ?? '',
          email: data['email'] ?? '',
          nickname: data['nickname'] ?? '',
          gender: data['gender'] ?? '');
    } on FirebaseAuthException catch (e) {
      throw Exception(AuthExceptionHandler.generateErrorMessage(e));
    }
  }

  // 회원가입
  Future<MyUser?> signUp(
      String email, String password, String displayName, String gender) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        await firebaseUser.updateDisplayName(displayName);
        await firebaseUser.reload();

        //TODO: Firestore 저장 로직 구현
        await _firestore.collection('user').doc(firebaseUser.uid).set({
          'uid': firebaseUser.uid,
          'email': firebaseUser.email ?? '',
          'nickname': displayName,
          'gender': gender
        });

        // 회원가입 후 즉시 로그아웃
        await _auth.signOut();

        return MyUser(
            uid: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            nickname: displayName,
            gender: gender);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw Exception(AuthExceptionHandler.generateErrorMessage(e));
    }
  }

  // 🔥 Firestore에서 현재 로그인된 유저 정보 가져오기
  Future<MyUser?> getCurrentUser() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    DocumentSnapshot doc =
        await _firestore.collection('user').doc(firebaseUser.uid).get();
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

  Future<String> updateProfileImage(File imageFile) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception("로그인이 필요합니다.");

      // 1. Storage에 업로드
      Reference ref = _storage.ref().child('profile_images/${user.uid}.jpg');
      UploadTask uploadTask = ref.putFile(imageFile);

      // 2. 업로드 진행상황 스트림 제공
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print('Upload progress: ${(progress * 100).toStringAsFixed(2)}%');
      });

      // 3. URL 획득
      String downloadUrl = await (await uploadTask).ref.getDownloadURL();

      // 4. Auth 프로필 업데이트
      await user.updatePhotoURL(downloadUrl);

      // 5. Firestore 프로필 업데이트
      await _firestore
          .collection('user')
          .doc(user.uid)
          .update({'profileImageUrl': downloadUrl});

      return downloadUrl;
    } catch (e) {
      throw Exception("프로필 이미지 업데이트 실패: $e");
    }
  }
}
