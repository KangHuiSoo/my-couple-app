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
  bool isCategoryView = true; // true = 카테고리, false = 장소목록
  late String selectedCategory; // 선택한 카테고리 (카테고리별 장소목록 출력을위해 사용)

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.coffee, 'label': '카페'},
    {'icon': Icons.fastfood_rounded, 'label': '음식점'},
    {'icon': Icons.park, 'label': '테마파크'},
    {'icon': Icons.image, 'label': '갤러리'},
    {'icon': Icons.apartment, 'label': '백화점'},
    {'icon': Icons.local_bar, 'label': 'BAR'},
    {'icon': Icons.local_convenience_store, 'label': '편의점'},
    {'icon': Icons.local_hospital, 'label': '병원'},
  ]; //카테고리 종류

  late GoogleMapController mapController;
  final LatLng _center =
      const LatLng(35.19343151233912, 129.0504196440337); //중심좌표

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCategorySelected(String category) async {
    // TODO: API 요청하여 장소 데이터 가져오기

    // 상태 업데이트: 장소 리스트로 변경
    setState(() {
      isCategoryView = false;
      selectedCategory = category;
      // places = fetchedPlaces;
    });
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

                    //검색창
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("이곳에서 검색 하세요"),
                                Icon(Icons.search)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 하단
                    DraggableScrollableSheet(
                      initialChildSize: 0.3,
                      minChildSize: 0.3,
                      maxChildSize: isCategoryView ? 0.3 : 1.0,
                      builder: (BuildContext context, ScrollController scrollController) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16))),
                          child: Column(
                            children: [
                              DraggableBar(),
                              Expanded(
                                child: isCategoryView
                                    ? _buildCategoryGrid()
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        controller: scrollController,
                                        itemCount: 5,
                                        itemBuilder: (context, index) {
                                          return _buildPlaceList();
                                        },
                                      ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ 카테고리 UI
  Widget _buildCategoryGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 한 줄에 4개씩
        childAspectRatio: 1, // 정사각형
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        var category = categories[index];
        return GestureDetector(
          onTap: () => {_onCategorySelected(category['label'])},
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: PRIMARY_COLOR,
                radius: 26.0,
                child: Icon(category['icon'], color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(category['label']),
            ],
          ),
        );
      },
    );
  }

  // ✅ 장소 목록 UI
  Widget _buildPlaceList() {
    return Column(
      children: [
        Row(
          children: [
            // Left side (Title and Subtitle)
            Expanded(
              child: ListTile(
                title: Row(
                  children: [
                    Text('현스시',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold)),
                    SizedBox(width: 12.0),
                    Text('음식점',
                        style: TextStyle(color: Colors.grey, fontSize: 12.0)),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('부산 해운대구 중동2로 2길'),
                    Text('150m 초량동'),
                    Text('평점 3.8'),
                    Text('054-777-1234'),
                  ],
                ),
              ),
            ),

            // Right side (Image)
            Container(
              width: 90, // 원하는 너비
              height: 90, // 원하는 높이
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                // border: Border.all(color: Colors.grey),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://picsum.photos/seed/picsum/100/100',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 12.0,
            )
          ],
        ),
        Divider(thickness: 0.5, indent: 10, endIndent: 10)
      ],
    );
  }

// Widget _buildPlaceList1(){
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//     child: Row(
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text('헌스시', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
//                 SizedBox(width: 10.0),
//                 Text('음식점', style: TextStyle(color: Colors.grey)),
//               ],
//             ),
//             SizedBox(height: 4.0),
//             Text('부산광역시 해운대구 중동2로 2길', style: TextStyle(fontSize: 14.0)),
//             Row(
//               children: [
//                 Text('138m', style: TextStyle(fontSize: 14.0)),
//                 SizedBox(width: 8.0),
//                 Text('초량동', style: TextStyle(fontSize: 14.0)),
//               ],
//             ),
//             Text('평점 3.8', style: TextStyle(fontSize: 14.0)),
//             Divider()
//           ],
//         ),
//       ],
//     ),
//   );
// }
}
