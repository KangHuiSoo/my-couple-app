import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_couple_app/core/constants/colors.dart';
import 'package:my_couple_app/core/ui/component/custom_button.dart';
import 'package:my_couple_app/core/ui/component/custom_text_field.dart';
import 'package:my_couple_app/ui/join/bottom_navigation_screen.dart';
import 'package:my_couple_app/ui/join/join_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 상단 로고
                Column(
                  children: [
                    SvgPicture.asset('assets/images/logo.svg',width: 56,height: 56),
                    SizedBox(height: 8),
                    Text('COUPLE', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: PRIMARY_COLOR)),
                  ],
                ),
                SizedBox(height: 40),

                CustomTextField(hintText: "ID 입력"), // ID 입력 필드
                SizedBox(height: 16),

                CustomTextField(hintText: "PW 입력"), // PW 입력 필드
                SizedBox(height: 24),

                // 로그인 버튼
                CustomButton(backgroundColor: PRIMARY_COLOR, textColor: Colors.white,buttonText: "로그인", onPressed: () {
                      Navigator.push(context, MaterialPageRoute( builder: (context) => BottomNavigationScreen()));
                }),
                SizedBox(height: 16),

                // ID 찾기, 회원 가입
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text('ID찾기', style: TextStyle(color: Colors.grey)),
                    ),
                    Text('|', style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => JoinScreen()));
                      },
                      child: Text('회원가입',style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
