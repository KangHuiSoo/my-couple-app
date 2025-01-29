import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class PlaceList extends StatelessWidget {
  const PlaceList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> places = [
      {
        'name': '헌스시',
        'address': '부산 해운대구 중동2로 2길',
        'rating': 4.3,
        'image': 'assets/images/default_background.jpg', // 이미지 경로
      },
      {
        'name': '올리스 카페',
        'address': '부산 해운대구 달맞이길 33',
        'rating': 4.8,
        'image': 'assets/images/default_background.jpg',
        'highlighted': true, // 선택된 아이템
      },
      {
        'name': '디무 커피',
        'address': '부산 기장군 일광읍 512',
        'rating': 4.5,
        'image': 'assets/images/default_background.jpg',
      },
      {
        'name': '디무 커피',
        'address': '부산 기장군 일광읍 512',
        'rating': 4.5,
        'image': 'assets/images/default_background.jpg',
      },
      {
        'name': '디무 커피',
        'address': '부산 기장군 일광읍 512',
        'rating': 4.5,
        'image': 'assets/images/default_background.jpg',
      },
      {
        'name': '디무 커피',
        'address': '부산 기장군 일광읍 512',
        'rating': 4.5,
        'image': 'assets/images/default_background.jpg',
      },
      {
        'name': '디무 커피',
        'address': '부산 기장군 일광읍 512',
        'rating': 4.5,
        'image': 'assets/images/default_background.jpg',
      }
    ];

    return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        // 내부 ListView 크기 제한
        physics: NeverScrollableScrollPhysics(),
        // 스크롤 비활성화
        itemCount: places.length,
        itemBuilder: (context, index) {
          final place = places[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 3.0, horizontal: 8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // 둥근 모서리 크기
              ),
              color: PRIMARY_CARD_COLOR,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.asset(
                      place['image'], // 이미지 경로
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        place['address'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star,
                              color: Colors.yellow[700], size: 16),
                          SizedBox(width: 4),
                          Text(
                            place['rating'].toString(),
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
