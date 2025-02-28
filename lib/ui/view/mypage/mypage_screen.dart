import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_couple_app/core/ui/component/profile_photo.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '마이페이지',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          ProfilePhoto(
              outsideSize: 120,
              insideSize: 100,
              radius: 52,
              imageUrl: 'assets/images/profile.png'),
          const SizedBox(height: 10),
          // 사용자 이름
          const Text(
            'woody',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          // 성별 표시
          const CircleAvatar(
            radius: 12,
            backgroundColor: Color(0xFF81D0D9),
            child: Text(
              'M',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // 메뉴 리스트
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(context, '회원 정보 수정', '/profileEdit'),
                _buildMenuItem(context, '비밀번호 변경', '/passwordEdit'),
                // _buildMenuItem(context, '커플인증/해제'),
                // _buildMenuItem(context, '앱설정'),
                // const SizedBox(height: 10),
                // _buildMenuItem(context, '로그아웃', isDisabled: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 메뉴 항목 빌드
  Widget _buildMenuItem(BuildContext context, String title, String router,
      {bool isDisabled = false}) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            context.go(router);
            // Navigator.push(context, MaterialPageRoute(builder: (context)=> page));
          },
          child: ListTile(
            title: Text(
              title,
              style: TextStyle(
                color: isDisabled ? Colors.grey : Colors.black,
                fontSize: 16,
              ),
            ),
            trailing: isDisabled
                ? null
                : const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: const Divider(height: 1, thickness: 1),
        ),
      ],
    );
  }
}
