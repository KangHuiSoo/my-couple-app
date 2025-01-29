import 'package:flutter/material.dart';

class PositionedDecoratedBox extends StatelessWidget {
  final double x;
  final double y;
  final String text;

  const PositionedDecoratedBox(
      {super.key, required this.x, required this.y, required this.text});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: y, // 텍스트의 Y 좌표 조정
        left: x, // 텍스트의 X 좌표 조정
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset(0, 2))
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
            child: Text(
              text,
              style: TextStyle(
                // backgroundColor: Colors.white,
                color: Color(0xFFb4b4b4), // 텍스트 색상
                fontSize: 14, // 텍스트 크기
                fontWeight: FontWeight.bold,
                // shadows: [
                //   Shadow(
                //     blurRadius: 4.0,
                //     color: Colors.black.withOpacity(0.5),
                //     offset: Offset(2, 2),
                //   ),
                // ],
              ),
            ),
          ),
        ));
  }
}
