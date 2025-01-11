import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_couple_app/const/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? backgroundImage;
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
  ];

  Future<void> _pickBackgroundImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        backgroundImage = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: _pickBackgroundImage,
            child: Container(
              height: screenSize.height * 0.8,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: backgroundImage != null
                      ? FileImage(File(backgroundImage!))
                      : AssetImage('assets/images/sample_image.jpg')
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 이미지 위 텍스트
          Positioned(
            top: 100, // 텍스트의 Y 좌표 조정
            left: 20, // 텍스트의 X 좌표 조정
            child: Text(
              '우리만난지',
              style: TextStyle(
                color: Colors.white, // 텍스트 색상
                fontSize: 24, // 텍스트 크기
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
          ),
          Positioned(
            top: 130, // 텍스트의 Y 좌표 조정
            left: 20, // 텍스트의 X 좌표 조정
            child: Text(
              'D+1082',
              style: TextStyle(
                color: Colors.white, // 텍스트 색상
                fontSize: 40, // 텍스트 크기
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
          ),
          Positioned(
            top: 200, // 텍스트의 Y 좌표 조정
            left: 20, // 텍스트의 X 좌표 조정
            child: Text(
              ' 자기생일 D-30 ',
              style: TextStyle(
                backgroundColor: Colors.white,
                color: Color(0xFFb4b4b4), // 텍스트 색상
                fontSize: 12, // 텍스트 크기
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
          Positioned(
            top: 220, // 텍스트의 Y 좌표 조정
            left: 20, // 텍스트의 X 좌표 조정
            child: Text(
              ' 크리스마스 D-40 ',
              style: TextStyle(
                backgroundColor: Colors.white,
                color: Color(0xFFb4b4b4), // 텍스트 색상
                fontSize: 12, // 텍스트 크기
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

          DraggableScrollableSheet(
            initialChildSize: 0.2, // 초기 높이 30%
            minChildSize: 0.2, // 최소 높이 20%
            maxChildSize: 0.7, // 최대 높이 100%
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10)
                    ]),
                child: Column(
                  children: [
                    //상단 Draggable 기호
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),

                    // DraggalbeScrollableSheet 몸체
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        controller: scrollController,
                        children: [
                          Center(
                            // 상단 프로필 사진, D-day 영역
                            child: Padding(
                              padding: const EdgeInsets.only(top: 26),
                              child: Container(
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 32, // 원 크기
                                      backgroundColor: PRIMARY_COLOR,
                                      backgroundImage: AssetImage(
                                          'assets/images/person1.jpg'), // 이미지 경로
                                    ),
                                    SizedBox(width: 12.0),
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.favorite,
                                          color: PRIMARY_COLOR,
                                          size: 20,
                                        ),
                                        Text(
                                          "2021. 12. 11",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: PRIMARY_COLOR,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 12.0),
                                    CircleAvatar(
                                      radius: 32, // 원 크기
                                      backgroundColor: PRIMARY_COLOR,
                                      backgroundImage: AssetImage(
                                          'assets/images/person1.jpg'), // 이미지 경로
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 32.0),
                          Container(
                            // 데이트 코스 영역
                            color: Colors.white,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "데이트 코스",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0),
                                          ),
                                          Icon(Icons.keyboard_arrow_right)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true, // 내부 ListView 크기 제한
                                    physics:
                                        NeverScrollableScrollPhysics(), // 스크롤 비활성화
                                    itemCount: places.length,
                                    itemBuilder: (context, index) {
                                      final place = places[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3.0, horizontal: 8.0),
                                        child: Card(
                                          color: PRIMARY_CARD_COLOR,
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    place['name'],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                          color: Colors
                                                              .yellow[700],
                                                          size: 16),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        place['rating']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                          Container(color: Colors.white, height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
