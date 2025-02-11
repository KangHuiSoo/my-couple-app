import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_couple_app/core/constants/colors.dart';
import 'package:my_couple_app/core/ui/component/custom_button.dart';
import 'package:my_couple_app/ui/home/home_screen.dart';
import 'couple_link_screen.dart';


class AskCoupleLinkScreen extends StatelessWidget {
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
                    Text('연인과 연결하기', style: TextStyle(
                      fontFamily: 'okddung',
                      color: PRIMARY_COLOR,
                      fontSize: 30.0
                    )),
                    SizedBox(height: 15.0),
                    Text("연인에게 커플 연결을 요청하거나"),
                    Text("요청받은 응답 링크를 직접 입력하여 연인과 연결하세요")
                  ],
                ),

                SizedBox(height: 40),

                // 로그인 버튼
                CustomButton(
                  onPressed: () {},
                  buttonText: "커플 요청하기",
                  textColor: Colors.white,
                  backgroundColor: PRIMARY_COLOR,
                ),
                SizedBox(height: 16.0),
                CustomButton(
                  onPressed: () {
                    context.go('/coupleLink');
                  },
                  buttonText: "링크 입력하기",
                  textColor: PRIMARY_COLOR,
                  backgroundColor: Colors.white,
                ),
                SizedBox(height: 8.0),
                TextButton(onPressed: (){
                  context.go('/');
                }, child: Text('나중에하기', style: TextStyle(color: Colors.grey)))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
