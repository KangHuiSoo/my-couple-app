import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
import 'package:my_couple_app/features/home/provider/home_provider.dart';

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

  @override
  void initState() {
    super.initState();
    // 현재 로그인한 사용자의 프로필 이미지 URL 을 가져옵니다
    _profileImageUrl = FirebaseAuth.instance.currentUser?.photoURL;

    // 위젯 생명 주기 중에 provider 를 수정 하는 것을 방지 하기 위해 Future 를 사용 합니다
    // 이렇게 하면 build 메서드가 완료된 후에 상태 변경이 이루어집니다
    Future(() {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final coupleId = ref.read(authViewModelProvider).user?.coupleId;
      print(" ====================");
      print(userId);
      print(coupleId);
      print(" ====================");
      if (userId != null) {
        ref.read(coupleViewModelProvider.notifier).loadCouplePartner(userId);
      }
      if (coupleId != null) {
        ref
            .read(homeViewModelProvider.notifier)
            .fetchNearestUpcomingPlaces(coupleId);
      }
    });
  }

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

  // 배너 위젯
  Widget _buildCoupleLinkBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              "아직 커플 연결이 완료되지 않았어요!\n링크를 생성해 상대방에게 공유해보세요.",
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
              minimumSize: const Size(80, 35),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("커플 연결 화면으로 이동합니다.")),
              );
              context.push("/askCoupleLink");
            },
            child: const Text("연결하기", style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final authState = ref.watch(authViewModelProvider);
    final coupleViewModel = ref.watch(coupleViewModelProvider.notifier);
    final partnerState = coupleViewModel.partner;
    final homeState = ref.watch(homeViewModelProvider);

    print('(home_screen.dart)HomeScreen build - Partner state: $partnerState');
    print('(home_screen.dart) My User 정보 : ${authState.user}');

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
                          if (authState.user?.coupleId == null)
                            _buildCoupleLinkBanner(context),
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
                                GestureDetector(child: CustomTitle(titleText: '다음 약속 장소'), onTap: (){
                                  context.push('/placeList');
                                },),

                                //TODO : 다가오는 가장 가까운 날짜의 데이트 장소 보여주기.
                                // DraggableSheet 내에 표시
                                if (homeState.isLoading)
                                  Center(child: CircularProgressIndicator())
                                else if (homeState.filteredPlaces.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text("다가오는 데이트 장소가 없어요."),
                                  )
                                else ...[
                                    ...homeState.filteredPlaces.map(
                                          (p) => Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 8,
                                              offset: Offset(0, 4),
                                            )
                                          ],
                                          border: Border.all(color: PRIMARY_COLOR.withOpacity(0.2)),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.place, color: PRIMARY_COLOR, size: 30),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    p.placeName,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    p.addressName ?? '',
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (p.selectedDate != null)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: PRIMARY_COLOR.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  "${p.selectedDate!.month}월 ${p.selectedDate!.day}일",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: PRIMARY_COLOR,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),

                                ]
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
