import 'package:flutter/material.dart';
import 'package:my_couple_app/component/custom_button.dart';
import 'package:my_couple_app/component/custom_text_field.dart';
import 'package:my_couple_app/const/colors.dart';
import 'package:my_couple_app/screen/couple_link_screen.dart';

class JoinScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('회원가입',style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,

        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ID 입력
                Text('ID', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),

                Row(
                  children: [
                    Expanded(child: CustomTextField(hintText: "영문 + 숫자 조합 8자 이상")),
                    SizedBox(width: 8),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: PRIMARY_COLOR),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text('중복확인',style: TextStyle(color: PRIMARY_COLOR)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // PW 입력
                Text('PW', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                CustomTextField(hintText: "영문 + 숫자 조합 5자 이상"), //id 입력 필드
                SizedBox(height: 16),

                // PW 확인
                Text('PW 확인', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                CustomTextField(hintText: ""),
                SizedBox(height: 16),

                // 이름 입력
                Text('이름', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                CustomTextField(hintText: ""),
                SizedBox(height: 16),

                // 성별 선택
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('성별', style : TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    Expanded(
                      child: CheckboxListTile(
                        value: true,
                        onChanged: (bool? value) {},
                        title: Text('남자'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        value: false,
                        onChanged: (bool? value) {},
                        title: Text('여자'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // 회원가입 버튼
                CustomButton(buttonText: "회원가입", onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CoupleLinkScreen()));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
