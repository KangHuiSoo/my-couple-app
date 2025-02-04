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
                    Text('링크 입력', style: TextStyle(
                        fontFamily: 'okddung',
                        color: PRIMARY_COLOR,
                        fontSize: 30.0
                    )),
                    SizedBox(height: 15.0),
                    Text("연인에게 요청받은 링크를 입력하세요"),
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
