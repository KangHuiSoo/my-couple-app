import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_couple_app/core/constants/colors.dart';
import 'package:my_couple_app/core/ui/component/custom_button.dart';
import 'package:my_couple_app/core/ui/component/custom_text_field.dart';
import 'package:my_couple_app/core/ui/component/draggable_bar.dart';
import 'package:my_couple_app/ui/place/place_search_screen.dart';

class PlaceAddScreen extends StatefulWidget {
  const PlaceAddScreen({super.key});

  @override
  State<PlaceAddScreen> createState() => _PlaceAddScreenState();
}

class _PlaceAddScreenState extends State<PlaceAddScreen> {
  final List<String> imageUrls = [
    'assets/images/default_background.jpg',
    'assets/images/default_background.jpg',
    'assets/images/default_background.jpg',
    'assets/images/default_background.jpg',
  ];

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(35.19343151233912, 129.0504196440337);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("장소추가"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 장소명 입력 필드
            Expanded(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Google Map 위젯
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition:
                        CameraPosition(target: _center, zoom: 15.0),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> PlaceSearchScreen()));
                        },
                        child: Container(
                          height: 44,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color(0xFFF3F8F9),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                )
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("이곳에서 검색 하세요"),
                                Icon(Icons.search)
                              ],
                            ),
                          ),
                        ),
                      )),
                  DraggableScrollableSheet(
                      initialChildSize: 0.2,
                      minChildSize: 0.2,
                      maxChildSize: 1.0,
                      builder: (BuildContext context,
                          ScrollController scrollController) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16))),
                          child: Column(
                            children: [
                              DraggableBar(),
                              Expanded(
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  controller: scrollController,
                                  children: [],
                                ),
                              )
                            ],
                          ),
                        );
                      })
                ],
              ),
            ),

            // 정보 텍스트 영역
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         children: [
            //           Text('헌스시',
            //               style: TextStyle(
            //                   fontSize: 18.0, fontWeight: FontWeight.bold)),
            //           SizedBox(width: 10.0),
            //           Text('식당', style: TextStyle(color: Colors.grey)),
            //         ],
            //       ),
            //       SizedBox(height: 4.0),
            //       Text('부산광역시 해운대구 중동2로 2길',
            //           style: TextStyle(fontSize: 14.0)),
            //       Row(
            //         children: List.generate(
            //           5,
            //               (index) => Icon(Icons.star, color: Colors.orange, size: 16),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 8.0),
            // // 이미지 가로 스크롤 영역
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: SizedBox(
            //     height: 100, // 고정된 높이를 설정
            //     child: ListView.builder(
            //       scrollDirection: Axis.horizontal,
            //       itemCount: imageUrls.length,
            //       itemBuilder: (context, index) {
            //         return Padding(
            //           padding: const EdgeInsets.only(right: 8.0),
            //           child: ClipRRect(
            //             borderRadius: BorderRadius.circular(10.0),
            //             child: Image.asset(
            //               imageUrls[index],
            //               width: 88, // 이미지 가로 크기
            //               height: 88, // 이미지 세로 크기
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ),

            SizedBox(height: 16.0),

            // 버튼 영역
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 버튼 간격 조정
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () {},
                      backgroundColor: Colors.white,
                      textColor: PRIMARY_COLOR,
                      buttonText: "취소",
                    ),
                  ),
                  SizedBox(width: 16.0), // 버튼 간격 추가
                  Expanded(
                    child: CustomButton(
                      onPressed: () {},
                      textColor: Colors.white,
                      backgroundColor: PRIMARY_COLOR,
                      buttonText: "추가",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
