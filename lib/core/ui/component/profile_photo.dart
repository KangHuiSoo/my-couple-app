import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class ProfilePhoto extends StatelessWidget {
  final double outsideSize;
  final double insideSize;
  final double radius;
  final String? imageUrl;

  const ProfilePhoto(
      {super.key,
      required this.outsideSize,
      required this.insideSize,
      this.imageUrl,
      required this.radius});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 외곽 테두리
        SizedBox(
          width: outsideSize,
          height: outsideSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: PRIMARY_COLOR,
                width: 1,
              ),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // 내부 테두리
        SizedBox(
          width: insideSize,
          // CircleAvatar 크기 + 내부 테두리 두께
          height: insideSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, // 내부 테두리 색상
            ),
          ),
        ),
        // 프로필 이미지
        CircleAvatar(
          radius: radius,
          backgroundColor: Colors.white,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
          child: imageUrl == null ? Icon(Icons.person) : null,
        )
      ],
    );
  }
}
