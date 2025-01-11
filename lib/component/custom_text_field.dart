import 'package:flutter/material.dart';

import '../const/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  const CustomTextField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return renderTextField();
  }

  Widget renderTextField() {
    return SizedBox(
      width: double.infinity,
      height: 44.0,
      child: TextFormField(
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[100],
            // border: InputBorder.none, // 기본 밑줄 없앰
            // focusedBorder: InputBorder.none, // 활성화 상태에서 밑줄 없앰
            enabledBorder: InputBorder.none, // 비활성화 상태에서 밑줄 없앰
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: PRIMARY_COLOR,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: PRIMARY_COLOR,
                width: 2.0,
              ),
            ),
          )
      ),
    );
  }
}
