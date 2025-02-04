import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_couple_app/core/constants/colors.dart';
import 'package:my_couple_app/core/ui/component/draggable_bar.dart';
import 'package:my_couple_app/ui/place/place_search_screen.dart';

class PlaceAddScreen extends StatefulWidget {
  const PlaceAddScreen({super.key});

  @override
  State<PlaceAddScreen> createState() => _PlaceAddScreenState();
}

class _PlaceAddScreenState extends State<PlaceAddScreen> {
  // final List<String> imageUrls = [
  //   'assets/images/default_background.jpg',
  //   'assets/images/default_background.jpg',
  //   'assets/images/default_background.jpg',
  //   'assets/images/default_background.jpg',
  // ];
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.coffee, 'label': '카페'},
    {'icon': Icons.fastfood_rounded, 'label': '음식점'},
    {'icon': Icons.park, 'label': '테마파크'},
    {'icon': Icons.image, 'label': '갤러리'},
    {'icon': Icons.apartment, 'label': '백화점'},
    {'icon': Icons.local_bar, 'label': 'BAR'},
    {'icon': Icons.local_convenience_store, 'label': '편의점'},
    {'icon': Icons.local_hospital, 'label':  '병원'},
  ];

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(35.19343151233912, 129.0504196440337);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text("장소 검색"),
      ),
      body: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.white),
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PlaceSearchScreen()));
                          },
                          child: Container(
                            height: 44,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withValues(alpha: 0.5),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: Offset(4, 4))
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("이곳에서 검색 하세요"),
                                  Icon(Icons.search)
                                ],
                              ),
                            ),
                          ),
                        )),
                    DraggableScrollableSheet(
                        initialChildSize: 0.3,
                        minChildSize: 0.3,
                        maxChildSize: 0.3,
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
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 24.0),
                                            child: _buildCategoryGrid(),
                                          ), // 같은 UI 반복
                                        ],
                                      )
                                    ],
                                  ),
                                ),
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

            ],
          ),
        ),
      ),

    );

  }

  Widget _buildCategoryGrid() {
    return Column(
      children: List.generate(
        (categories.length / 4).ceil(), // 4개씩 묶어서 그룹 생성
            (rowIndex) {
          final startIndex = rowIndex * 4;
          final endIndex = (startIndex + 4 < categories.length) ? startIndex + 4 : categories.length;
          final rowItems = categories.sublist(startIndex, endIndex); // 4개씩 가져오기

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: rowItems.map((category) {
                return Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: PRIMARY_COLOR,
                      radius: 26.0,
                      child: Icon(category['icon'], color: Colors.white),
                    ),
                    Text(category['label']),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
