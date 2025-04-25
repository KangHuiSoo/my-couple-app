import 'package:flutter/material.dart';

class PositionedText extends StatelessWidget {
  final double x;
  final double y;
  final String text;
  const PositionedText({super.key, required this.x, required this.y, required this.text});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: y, // 텍스트의 Y 좌표 조정
      left: x, // 텍스트의 X 좌표 조정
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'okddung',
          color: Colors.white,
          // 텍스트 색상
          fontSize: 40,
          // 텍스트 크기
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 4.0,
              color: Colors.black.withOpacity(0.5),
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }
}
