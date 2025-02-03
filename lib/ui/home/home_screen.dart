import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_couple_app/core/constants/colors.dart';
import 'package:my_couple_app/core/ui/component/custom_title.dart';
import 'package:my_couple_app/core/ui/component/draggable_bar.dart';
import 'package:my_couple_app/core/ui/component/place_list.dart';
import 'package:my_couple_app/core/ui/component/positioned_decorated_box.dart';
import 'package:my_couple_app/core/ui/component/positioned_text.dart';
import 'package:my_couple_app/core/ui/component/profile_photo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? backgroundImage;

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
          PositionedText(x: 20, y: 80, text: 'D+987'),
          PositionedDecoratedBox(x: 20, y: 150, text: '생일 D-30'),
          PositionedDecoratedBox(x: 20, y: 180, text: '크리스마스 D-30'),
          DraggableScrollableSheet(
            initialChildSize: 0.2, // 초기 높이 30%
            minChildSize: 0.2, // 최소 높이 20%
            maxChildSize: 0.7, // 최대 높이 100%
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    //상단 Draggable 기호
                    DraggableBar(),

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
                                    ProfilePhoto(outsideSize: 80, insideSize: 72, radius: 32, imageUrl: 'assets/images/profile.png'),
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
                                    ProfilePhoto(outsideSize: 80, insideSize: 72, radius:32, imageUrl: 'assets/images/profile.png'),
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
                                CustomTitle(titleText: '데이트 장소'),
                                PlaceList(isEditing: false)
                              ],
                            ),
                          ),
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
