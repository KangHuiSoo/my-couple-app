import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_couple_app/core/constants/colors.dart';
import 'package:my_couple_app/core/ui/component/place_list.dart';
import 'package:my_couple_app/features/place/viewmodel/place_view_model.dart';

import '../model/place.dart';

class PlaceListScreen extends ConsumerStatefulWidget {
  const PlaceListScreen({super.key});

  @override
  ConsumerState<PlaceListScreen> createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends ConsumerState<PlaceListScreen> {
  bool isEditing = false;
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  final categories = [
    '전체', '카페', '음식점', '관광명소', '숙박', '주차장', '문화시설', '대형마트', '편의점'
  ];
  String selectedCategory = '전체';
  List<Place> places = [];
  List<bool> selectedItems = [];

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    try {
      final loadedPlaces = ref.read(placeNotifierProvider.notifier).places;
      setState(() {
        places = loadedPlaces;
        selectedItems = List.generate(places.length, (_) => false);
      });
    } catch (e) {
      print('장소 로딩 실패: $e');
    }
  }

  void toggleCheckbox(int index) {
    setState(() {
      selectedItems[index] = !selectedItems[index];
    });
  }

  void resetCheckboxes() {
    setState(() {
      selectedItems = List.generate(selectedItems.length, (_) => false);
    });
  }

  List<Place> get filteredPlaces {
    if (selectedCategory == '전체') return places;
    return places.where((place) => place.categoryGroupName == selectedCategory).toList();
  }

  TextStyle categoryTextStyle(String category) {
    return TextStyle(
      color: category == selectedCategory ? Colors.black : Colors.grey,
      fontWeight: category == selectedCategory ? FontWeight.bold : FontWeight.normal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: const Text('약속장소'),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildCategoryTabs(),
              const Divider(
                height: 0.001,
                color: Color(0xFFB4B4B4),
                thickness: 0.5,
                indent: 16.0,
                endIndent: 16.0,
              ),
              _buildPlaceCountAndEditButton(),
              PlaceList(
                isEditing: isEditing,
                places: filteredPlaces,
                selectedItems: selectedItems,
                onCheckboxChanged: toggleCheckbox,
                onReset: resetCheckboxes,
                onEditingChanged: (value) {
                  setState(() {
                    isEditing = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: isEditing ? _buildEditingBottomBar() : const SizedBox.shrink(),
      floatingActionButton: isEditing
          ? const SizedBox.shrink()
          : FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        onPressed: () => context.push('/datePicker'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return TextButton(
            onPressed: () => setState(() => selectedCategory = category),
            child: Text(category, style: categoryTextStyle(category)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlaceCountAndEditButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'total ${filteredPlaces.length}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
          ),
          TextButton(
            onPressed: () => setState(() => isEditing = true),
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              '편집',
              style: TextStyle(color: Colors.grey, fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditingBottomBar() {
    return Container(
      color: PRIMARY_COLOR,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                isEditing = false;
                resetCheckboxes();
              });
            },
            icon: const Icon(Icons.cancel, color: Colors.white),
            label: const Text('취소', style: TextStyle(color: Colors.white)),
          ),
          TextButton.icon(
            onPressed: () {
              // 삭제 기능은 추후 구현
            },
            icon: const Icon(Icons.delete, color: Colors.white),
            label: const Text('삭제', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:my_couple_app/core/constants/colors.dart';
// import 'package:my_couple_app/core/ui/component/place_list.dart';
// import 'package:my_couple_app/features/place/viewmodel/place_view_model.dart';
//
// import '../model/place.dart';
//
// class PlaceListScreen extends ConsumerStatefulWidget {
//   const PlaceListScreen({super.key});
//
//   @override
//   ConsumerState<PlaceListScreen> createState() => _PlaceListScreenState();
// }
//
// class _PlaceListScreenState extends ConsumerState<PlaceListScreen> {
//   bool isEditing = false; // 편집 모드 상태
//   DateTime focusedDay = DateTime.now();
//   DateTime selectedDay = DateTime.utc(
//       DateTime.now().year, DateTime.now().month, DateTime.now().day);
//
//   final categories = [
//     '전체',
//     '카페',
//     '음식점',
//     '관광명소',
//     '숙박',
//     '주차장',
//     '문화시설',
//     '대형마트',
//     '편의점'
//   ];
//   String selectedCategory = '전체';
//   List<Place> places = [];
//
//   // final List<Map<String, dynamic>> places = [
//   //   {'name': '헌스시', 'category': '식당', 'address': '부산 해운대구 중동2로 2길', 'rating': 4.3, 'image': 'https://picsum.photos/seed/picsum/100/100'},
//   //   {'name': '올리스 카페', 'category': '카페', 'address': '부산 해운대구 달맞이길 33', 'rating': 4.8, 'image': 'https://picsum.photos/seed/picsum/100/100'},
//   //   {'name': '빅다방 카페', 'category': '카페', 'address': '부산 사상구 빅도로 31', 'rating': 4.8, 'image': 'https://picsum.photos/seed/picsum/100/100'},
//   //   {'name': '스타 바', 'category': 'bar', 'address': '부산 해운대구 바거리 12', 'rating': 4.6, 'image': 'https://picsum.photos/seed/picsum/100/100'},
//   //   {'name': '백화점 쇼핑몰', 'category': '백화점', 'address': '부산 센텀시티 123', 'rating': 4.5, 'image': 'https://picsum.photos/seed/picsum/100/100'},
//   //   {'name': '테마파크', 'category': '테마파크', 'address': '부산 기장군 45번지', 'rating': 4.7, 'image': 'https://picsum.photos/seed/picsum/100/100'},
//   //   {'name': '장 갤러리', 'category': '갤러리', 'address': '부산 기장군 45번지', 'rating': 4.7, 'image': 'https://picsum.photos/seed/picsum/100/100'},
//   // ];
//
//   late List<bool> selectedItems;
//
//   @override
//   void initState() {
//     super.initState();
//     // 데이터 로딩
//     _loadPlaces();
//     selectedItems = List.generate(places.length, (_) => false);
//   }
//
//   Future<void> _loadPlaces() async {
//     try {
//       final loadedPlaces = ref.read(placeNotifierProvider.notifier).places;
//       setState(() {
//         places = loadedPlaces;
//         selectedItems = List.generate(places.length, (_) => false);
//       });
//     } catch (e) {
//       print('장소 로딩 실패: $e');
//     }
//   }
//
//   void toggleCheckbox(int index) {
//     setState(() {
//       selectedItems[index] = !selectedItems[index];
//     });
//   }
//
//   void resetCheckboxes() {
//     setState(() {
//       selectedItems = List.generate(selectedItems.length, (_) => false);
//     });
//   }
//
//   List<Place> get filteredPlaces {
//     if (selectedCategory == '전체') {
//       return places;
//     }
//     return places
//         .where((place) => place.categoryGroupName == selectedCategory)
//         .toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: false,
//         backgroundColor: Colors.white,
//         title: Text('약속장소'),
//       ),
//       body: DecoratedBox(
//         decoration: BoxDecoration(color: Colors.white),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: categories
//                       .map(
//                         (category) => TextButton(
//                           onPressed: () {
//                             setState(() {
//                               selectedCategory = category;
//                             });
//                           },
//                           child: Text(
//                             category,
//                             style: TextStyle(
//                               color: category == selectedCategory
//                                   ? Colors.black
//                                   : Colors.grey,
//                               fontWeight: category == selectedCategory
//                                   ? FontWeight.bold
//                                   : FontWeight.normal,
//                             ),
//                           ),
//                         ),
//                       )
//                       .toList(),
//                 ),
//               ),
//               Divider(
//                   height: 0.001,
//                   color: Color(0xFFB4B4B4),
//                   thickness: 0.5,
//                   indent: 16.0,
//                   endIndent: 16.0),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 20.0, vertical: 12.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'total ${filteredPlaces.length.toString()}',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12.0,
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         setState(() {
//                           isEditing = true;
//                         });
//                       },
//                       style: TextButton.styleFrom(
//                           minimumSize: Size.zero,
//                           padding: EdgeInsets.zero,
//                           tapTargetSize: MaterialTapTargetSize.shrinkWrap),
//                       child: Text(
//                         '편집',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 12.0,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               PlaceList(
//                   isEditing: isEditing,
//                   places: filteredPlaces,
//                   selectedItems: selectedItems,
//                   onCheckboxChanged: toggleCheckbox,
//                   onReset: resetCheckboxes,
//                   onEditingChanged: (value) {
//                     setState(() {
//                       isEditing = value;
//                     });
//                   })
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: isEditing
//           ? Container(
//               color: PRIMARY_COLOR,
//               padding: EdgeInsets.all(10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   TextButton.icon(
//                     onPressed: () {
//                       setState(() {
//                         isEditing = false;
//                         resetCheckboxes();
//                         // widget.onEditingChanged!(false);
//                         // selectedItems = [false, false, false];
//                       });
//                     },
//                     icon: Icon(Icons.cancel, color: Colors.white),
//                     label: Text('취소', style: TextStyle(color: Colors.white)),
//                   ),
//                   TextButton.icon(
//                     onPressed: () {
//                       setState(() {
//                         // selectedItems =
//                         //     List.generate(selectedItems.length, (_) => false);
//                       });
//                     },
//                     icon: Icon(Icons.delete, color: Colors.white),
//                     label: Text('삭제', style: TextStyle(color: Colors.white)),
//                   ),
//                 ],
//               ),
//             )
//           : SizedBox.shrink(),
//       floatingActionButton: isEditing
//           ? SizedBox.shrink()
//           : FloatingActionButton(
//               backgroundColor: PRIMARY_COLOR,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(50.0),
//               ),
//               onPressed: () {
//                 context.push('/datePicker');
//                 // Navigator.push(context,
//                 //     MaterialPageRoute(builder: (context) => DatepickerScreen()));
//               },
//               child: Icon(Icons.add, color: Colors.white),
//             ),
//     );
//   }
//
// // void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
// //   // 1. 선택한 날짜(=selectedDay)를 state에서 관리 하도록함
// //   print(selectedDay);
// //   setState(() {
// //     this.selectedDay = selectedDay; // 2.데이터값을 바꿔주기때문에 다시 빌드됨
// //     this.focusedDay = selectedDay;
// //   });
// // }
// }
