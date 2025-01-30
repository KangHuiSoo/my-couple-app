import 'package:flutter/material.dart';
import 'package:my_couple_app/core/constants/Genders.dart';
import 'package:my_couple_app/core/constants/colors.dart';
import 'package:my_couple_app/core/ui/component/custom_button.dart';
import 'package:my_couple_app/core/ui/component/custom_text_field.dart';

import '../../core/ui/component/profile_photo.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  Genders? genders = Genders.man;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('프로필 수정'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Column(
            children: [
              Stack(
                children: [
                  ProfilePhoto(
                    outsideSize: 120,
                    insideSize: 100,
                    radius: 52,
                    imageUrl: 'assets/images/profile.png',
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
