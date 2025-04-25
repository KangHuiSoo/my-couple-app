import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_couple_app/core/constants/colors.dart';
import 'package:my_couple_app/core/ui/component/custom_button.dart';
import 'package:my_couple_app/core/ui/component/custom_text_field.dart';
import 'package:my_couple_app/features/auth/provider/auth_provider.dart';
import 'package:my_couple_app/features/auth/viewmodel/auth_view_model.dart';

class JoinScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends ConsumerState<JoinScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String selectedGender = '남자'; // 기본 선택값
  TextEditingController _idController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _displayNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    // 🔥 상태 변화를 감지하여 처리 (ref.listen을 build 내부에서 사용)
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.errorMessage != null) {
        debugPrint("회원가입 실패: ${next.errorMessage}");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      } else if (next.user != null) {
        context.go('/askCoupleLink');
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          '회원가입',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ID 입력
                Text('ID',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                Row(
                  children: [
                    Expanded(
                        child: CustomTextField(
                            controller: _idController,
                            hintText: "영문 + 숫자 조합 8자 이상")),
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
                        child: Text('중복확인',
                            style: TextStyle(color: PRIMARY_COLOR)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // PW 입력
                Text('PW',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                CustomTextField(
                    controller: _passwordController,
                    hintText: "영문 + 숫자 조합 5자 이상",
                    isObscureText: true),
                SizedBox(height: 16),

                // PW 확인
                Text('PW 확인',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                CustomTextField(
                  hintText: "",
                  isObscureText: true,
                ),
                SizedBox(height: 16),

                // 이름 입력
                Text('이름',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                CustomTextField(
                    controller: _displayNameController, hintText: ""),
                SizedBox(height: 16),

                // 성별 선택
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '성별',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        value: '남자',
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value!;
                            print(selectedGender);
                          });
                        },
                        title: Text('남자'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        value: '여자',
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value!;
                            print(selectedGender);
                          });
                        },
                        title: Text('여자'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // 회원가입 버튼
                CustomButton(
                  backgroundColor: PRIMARY_COLOR,
                  textColor: Colors.white,
                  buttonText: "회원가입",
                  onPressed: () async {
                    if (formKey.currentState == null) {
                      return;
                    }

                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      await ref.read(authViewModelProvider.notifier).signUp(
                          _idController.text,
                          _passwordController.text,
                          _displayNameController.text,
                          selectedGender);
                    }
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
