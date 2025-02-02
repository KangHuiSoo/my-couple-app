import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_couple_app/core/constants/colors.dart';
import 'package:my_couple_app/core/ui/component/custom_button.dart';
import 'package:my_couple_app/core/ui/component/custom_text_field.dart';

import 'package:my_couple_app/ui/join/bottom_navigation_screen.dart';
import 'package:my_couple_app/ui/join/join_screen.dart';


class CoupleLinkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 상단 로고
                Column(
                  children: [
                    SvgPicture.asset(
                      'assets/images/welcome_logo.svg',
                      width: 144,
                      height: 34,
                    ),
                    SizedBox(height: 15.0),
                    Text("커플 링크를 인증해주시면"),
                    Text("두사람의 데이트 일정과 사진을 공유할 수 있어요")
                  ],
                ),

                SizedBox(height: 40),

                // ID 입력 필드
                CustomTextField(hintText: "커플 링크 입력"),

                SizedBox(height: 16),

                // 로그인 버튼
                SizedBox(
                  height: 44,
                  width: double.infinity,
                  child: CustomButton(
                    onPressed: () {},
                    buttonText: "연결",
                    textColor: Colors.white,
                    backgroundColor: PRIMARY_COLOR,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
