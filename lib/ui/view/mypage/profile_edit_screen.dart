import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_couple_app/core/constants/genders.dart';
import 'package:my_couple_app/core/constants/colors.dart';
import 'package:my_couple_app/core/ui/component/custom_button.dart';
import 'package:my_couple_app/core/ui/component/custom_text_field.dart';
import 'package:my_couple_app/core/ui/component/profile_photo.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  Genders? genders = Genders.man;
  String? _profileImageUrl;

  Future<void> _updateProfileImage() async {
    print("=-=-=-=--=-");
    print(FirebaseAuth.instance.currentUser);
    try {
      final XFile? pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;

      final File file = File(pickedImage.path);
      final ref = FirebaseStorage.instance
          .ref('profile_images/${FirebaseAuth.instance.currentUser!.uid}');
      await ref.putFile(file);

      final String downloadUrl = await ref.getDownloadURL();
      await FirebaseAuth.instance.currentUser?.updatePhotoURL(downloadUrl);

      setState(() {
        _profileImageUrl = downloadUrl;
      });
    } catch (e) {
      debugPrint('프로필 사진 변경 실패: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _profileImageUrl = FirebaseAuth.instance.currentUser?.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(CupertinoIcons.back)),
        title: Text('프로필 수정'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Column(
            children: [
              GestureDetector(
                onTap: _updateProfileImage,
                child: Stack(
                  children: [
                    ProfilePhoto(
                      outsideSize: 120,
                      insideSize: 100,
                      radius: 52,
                      imageUrl: _profileImageUrl,
                    ),
                    Positioned(
                      top: 90,
                      left: 90,
                      child: Icon(
                        Icons.camera_alt,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      '닉네임',
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 6.0),
                    child: CustomTextField(hintText: "woody"),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      '성별',
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<Genders>(
                          title: const Text('남자'),
                          value: Genders.man,
                          groupValue: genders,
                          onChanged: (Genders? value) {
                            setState(() {
                              genders = value;
                              print(genders);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<Genders>(
                          title: const Text('여자'),
                          value: Genders.woman,
                          groupValue: genders,
                          onChanged: (Genders? value) {
                            setState(() {
                              genders = value;
                              print(genders);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(26.0),
            child: CustomButton(
              onPressed: () {},
              buttonText: '프로필 변경',
              backgroundColor: PRIMARY_COLOR,
              textColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
