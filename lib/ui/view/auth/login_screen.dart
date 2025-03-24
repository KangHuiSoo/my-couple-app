import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:my_couple_app/core/constants/colors.dart';
import 'package:my_couple_app/core/ui/component/custom_button.dart';
import 'package:my_couple_app/core/ui/component/custom_text_field.dart';
import 'package:my_couple_app/data/provider/auth/auth_provider.dart';
import '../auth/auth_view_model.dart';

class LoginScreen extends ConsumerWidget {
  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController _idController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    // 🔥 상태 변화를 감지하여 처리 (ref.listen을 build 내부에서 사용)
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      } else if (next.user != null) {
        context.go('/home');
      }
    });

    // print('===================================');
    // print(authState.user);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 상단 로고
                Column(
                  children: [
                    SvgPicture.asset('assets/images/logo.svg',
                        width: 56, height: 56),
                    SizedBox(height: 8),
                    Text('데플리',
                        style: TextStyle(
                            fontFamily: 'okddung',
                            fontSize: 30,
                            color: PRIMARY_COLOR)),
                  ],
                ),
                SizedBox(height: 40),

                CustomTextField(
                    controller: _idController, hintText: "ID 입력"), // ID 입력 필드
                SizedBox(height: 16),

                CustomTextField(
                    controller: _passwordController,
                    hintText: "PW 입력",
                    isObscureText: true), // PW 입력 필드
                SizedBox(height: 24),

                // 로그인 버튼
                CustomButton(
                    backgroundColor: PRIMARY_COLOR,
                    textColor: Colors.white,
                    buttonText: "로그인",
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        formKey.currentState!.save();
                        await ref.read(authViewModelProvider.notifier).signIn(
                            _idController.text, _passwordController.text);
                      }
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
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => JoinScreen()));
                        context.push('/join');
                      },
                      child: Text('회원가입', style: TextStyle(color: Colors.grey)),
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
