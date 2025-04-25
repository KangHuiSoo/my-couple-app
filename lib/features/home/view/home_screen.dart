import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_couple_app/core/constants/colors.dart';
import 'package:my_couple_app/core/ui/component/custom_title.dart';
import 'package:my_couple_app/core/ui/component/draggable_bar.dart';
import 'package:my_couple_app/core/ui/component/place_list.dart';
import 'package:my_couple_app/core/ui/component/positioned_decorated_box.dart';
import 'package:my_couple_app/core/ui/component/positioned_text.dart';
import 'package:my_couple_app/core/ui/component/profile_photo.dart';
import 'package:my_couple_app/features/auth/provider/auth_provider.dart';
import 'package:my_couple_app/features/couple/viewmodel/couple_view_model.dart';

import '../../place/model/place.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _profileImageUrl;
  String? backgroundImage;
  final List<Place> places = [];
  // final List<Map<String, dynamic>> places = [
  //   {'name': '헌스시', 'category': '식당', 'address': '부산 해운대구 중동2로 2길', 'rating': 4.3, 'image': 'https://picsum.photos/seed/picsum/100/100'},
  //   {'name': '올리스 카페', 'category': '카페', 'address': '부산 해운대구 달맞이길 33', 'rating': 4.8, 'image': 'https://picsum.photos/seed/picsum/100/100'},
  //   {'name': '빅다방 카페', 'category': '카페', 'address': '부산 사상구 빅도로 31', 'rating': 4.8, 'image': 'https://picsum.photos/seed/picsum/100/100'},
  //   {'name': '스타 바', 'category': 'bar', 'address': '부산 해운대구 바거리 12', 'rating': 4.6, 'image': 'https://picsum.photos/seed/picsum/100/100'},
  //   {'name': '백화점 쇼핑몰', 'category': '백화점', 'address': '부산 센텀시티 123', 'rating': 4.5, 'image': 'https://picsum.photos/seed/picsum/100/100'},
  //   {'name': '테마파크', 'category': '테마파크', 'address': '부산 기장군 45번지', 'rating': 4.7, 'image': 'https://picsum.photos/seed/picsum/100/100'},
  // ];

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
  void initState() {
    super.initState();
    // 현재 로그인한 사용자의 프로필 이미지 URL을 가져옵니다
    _profileImageUrl = FirebaseAuth.instance.currentUser?.photoURL;

    // 위젯 생명주기 중에 provider를 수정하는 것을 방지하기 위해 Future를 사용합니다
    // 이렇게 하면 build 메서드가 완료된 후에 상태 변경이 이루어집니다
    Future(() {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        ref.read(coupleViewModelProvider.notifier).loadCouplePartner(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final authState = ref.watch(authViewModelProvider);
    final coupleViewModel = ref.watch(coupleViewModelProvider.notifier);
    final partnerState = coupleViewModel.partner;

    print('HomeScreen build - Partner state: $partnerState');

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
            initialChildSize: 0.2,
            minChildSize: 0.2,
            maxChildSize: 0.7,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    DraggableBar(),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        controller: scrollController,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 26),
                              child: Container(
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ProfilePhoto(
                                      outsideSize: 80,
                                      insideSize: 72,
                                      radius: 32,
                                      imageUrl: authState.profileImageUrl ??
                                          _profileImageUrl,
                                    ),
                                    SizedBox(width: 16.0),
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          "D - 1200",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: PRIMARY_COLOR,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 16.0),
                                    partnerState.when(
                                      data: (partner) {
                                        print('Partner data in UI: $partner');
                                        return ProfilePhoto(
                                          outsideSize: 80,
                                          insideSize: 72,
                                          radius: 32,
                                          imageUrl: partner?.profileImageUrl,
                                        );
                                      },
                                      loading: () {
                                        print('Partner state is loading');
                                        return CircularProgressIndicator();
                                      },
                                      error: (error, stack) {
                                        print('Partner state error: $error');
                                        return Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 32,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 32.0),
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                CustomTitle(titleText: '데이트 장소'),
                                PlaceList(
                                  isEditing: false,
                                  places: places,
                                )
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
