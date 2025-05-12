import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_couple_app/core/constants/colors.dart';
import 'package:my_couple_app/core/ui/component/place_list.dart';
import 'package:my_couple_app/features/auth/provider/auth_provider.dart';
import 'package:my_couple_app/features/couple/viewmodel/couple_view_model.dart';
import 'package:my_couple_app/features/place/provider/place_provider.dart';
import '../model/place.dart';

class PlaceListScreen extends ConsumerStatefulWidget {
  const PlaceListScreen({super.key});

  @override
  ConsumerState<PlaceListScreen> createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends ConsumerState<PlaceListScreen> {
  bool isEditing = false;
  DateTime focusedDay = DateTime.now();
  // DateTime selectedDay = DateTime.utc(
  //     DateTime.now().year, DateTime.now().month, DateTime.now().day);


  final categories = [
    '전체',
    '카페',
    '음식점',
    '관광명소',
    '숙박',
    '주차장',
    '문화시설',
    '대형마트',
    '편의점'
  ];
  String selectedCategory = '전체';

  @override
  void initState() {
    super.initState();
  }

  void _showDateSelector(BuildContext context, List<DateTime> availableDates,
      ValueChanged<DateTime> onDateSelected) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: availableDates.length,
          itemBuilder: (context, index) {
            final date = availableDates[index];
            final formatted = "${date.year}년 ${date.month}월 ${date.day}일";

            return ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.grey),
              title: Text(formatted),
              onTap: () {
                Navigator.pop(context); // 닫기
                onDateSelected(date); // 선택 콜백
              },
            );
          },
        );
      },
    );
  }

  TextStyle categoryTextStyle(String category) {
    return TextStyle(
      color: category == selectedCategory ? Colors.black : Colors.grey,
      fontWeight:
          category == selectedCategory ? FontWeight.bold : FontWeight.normal,
    );
  }

  List<Place> sortByPriority(
      List<Place> places, String myUid, String partnerUid) {
    return [...places]..sort((a, b) {
        final aMy = a.userRatings?[myUid];
        final aPt = a.userRatings?[partnerUid];
        final bMy = b.userRatings?[myUid];
        final bPt = b.userRatings?[partnerUid];

        final aAvg = (aMy != null && aPt != null) ? (aMy + aPt) / 2 : -1;
        final bAvg = (bMy != null && bPt != null) ? (bMy + bPt) / 2 : -1;

        return bAvg.compareTo(aAvg);
      });
  }

  @override
  Widget build(BuildContext context) {
    final myUid = ref.watch(authViewModelProvider).user?.uid;
    final partnerUid =
        ref.watch(coupleViewModelProvider.notifier).partner.value?.uid;

    // final watchedPlaces = ref.watch(allPlacesByCoupleProvider);
    final watchedPlaces = ref.watch(placesForSelectedDateProvider);
    final selectedIds = ref.watch(checkedPlaceIdSetProvider);
    final notifier = ref.read(checkedPlaceIdSetProvider.notifier);
    final registeredDates = ref.watch(filteredPlaceDateProvider);
    final selectedDay = ref.watch(selectedFilterDateProvider);

    final filteredPlaces = selectedCategory == '전체'
        ? sortByPriority(watchedPlaces, myUid!, partnerUid!)
        : sortByPriority(
            watchedPlaces
                .where((p) => p.categoryGroupName == selectedCategory)
                .toList(),
            myUid!,
            partnerUid!,
          );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: const Text('약속장소'),
        actions: [
          TextButton(
            onPressed: () {
              _showDateSelector(context, registeredDates, (selected) {
                print('선택된 날짜: $selected');
                ref.read(selectedFilterDateProvider.notifier).state = selected;
                setState(() {});
              });
            },
            child: Text(
              selectedDay != null
                  ? DateFormat('yyyy년 M월 d일').format(selectedDay)
                  : "날짜 선택",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildCategoryTabs2(),
              _buildPlaceCountAndEditButton(filteredPlaces),
              PlaceList(
                isEditing: isEditing,
                places: filteredPlaces,
                selectedIds: selectedIds,
                onCheckboxToggled: notifier.toggle,
                onEditingChanged: (value) {
                  setState(() {
                    isEditing = value;
                  });
                },
                myUid: myUid!,
                partnerUid: partnerUid!,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          isEditing ? _buildEditingBottomBar() : const SizedBox.shrink(),
      floatingActionButton: isEditing
          ? const SizedBox.shrink()
          : FloatingActionButton(
              backgroundColor: PRIMARY_COLOR,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              onPressed: () => context.push('/datePicker'),
              child: const Icon(Icons.add, color: Colors.white),
            ),
    );
  }

  Widget _buildCategoryTabs2() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          return ChoiceChip(
            label: Text(category),
            selected: category == selectedCategory,
            onSelected: (_) => setState(() => selectedCategory = category),
            selectedColor: PRIMARY_COLOR.withOpacity(0.2),
            backgroundColor: Colors.grey[200],
            labelStyle: categoryTextStyle(category),
          );
        },
      ),
    );
  }

  Widget _buildPlaceCountAndEditButton(List<Place> filteredPlaces) {
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
              });
              ref.read(checkedPlaceIdSetProvider.notifier).clear();
            },
            icon: const Icon(Icons.cancel, color: Colors.white),
            label: const Text('취소', style: TextStyle(color: Colors.white)),
          ),
          TextButton.icon(
            onPressed: () {
              // 삭제 기능은 추후 구현 예정
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
// import 'package:my_couple_app/features/auth/provider/auth_provider.dart';
// import 'package:my_couple_app/features/couple/viewmodel/couple_view_model.dart';
// import 'package:my_couple_app/features/place/provider/place_provider.dart';
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
//   bool isEditing = false;
//   DateTime focusedDay = DateTime.now();
//   DateTime selectedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
//
//   final categories = [
//     '전체', '카페', '음식점', '관광명소', '숙박', '주차장', '문화시설', '대형마트', '편의점'
//   ];
//   String selectedCategory = '전체';
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   TextStyle categoryTextStyle(String category) {
//     return TextStyle(
//       color: category == selectedCategory ? Colors.black : Colors.grey,
//       fontWeight: category == selectedCategory ? FontWeight.bold : FontWeight.normal,
//     );
//   }
//
//   // 커플의 장소에대한 평균평점에 따른 정렬 함수!
//   List<Place> sortByPriority(
//       List<Place> places, String myUid, String partnerUid) {
//     return [...places] // 원본 리스트 복사
//       ..sort((a, b) {
//         final aMy = a.userRatings?[myUid];
//         final aPt = a.userRatings?[partnerUid];
//         final bMy = b.userRatings?[myUid];
//         final bPt = b.userRatings?[partnerUid];
//
//         final aAvg = (aMy != null && aPt != null) ? (aMy + aPt) / 2 : -1;
//         final bAvg = (bMy != null && bPt != null) ? (bMy + bPt) / 2 : -1;
//
//         return bAvg.compareTo(aAvg); // 높은 순 정렬
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final myUid = ref.watch(authViewModelProvider).user?.uid;
//     final partnerUid = ref.watch(coupleViewModelProvider.notifier).partner.value?.uid;
//
//     print('(place_list_screen.dart) my uid: $myUid');
//     print('(place_list_screen.dart) Partner uid: $partnerUid');
//
//     final watchedPlaces = ref.watch(placeListProvider); // 장소 조회
//     final selectedIds = ref.watch(selectedPlaceIdsProvider);
//     final notifier = ref.read(selectedPlaceIdsProvider.notifier); //
//
//     print(watchedPlaces);
//     // final filteredPlaces = selectedCategory == '전체'
//     //     ? watchedPlaces
//     //     : watchedPlaces.where((p) => p.categoryGroupName == selectedCategory).toList();//
//
//     // ⭐️ 우선순위 정렬 적용
//     final filteredPlaces = selectedCategory == '전체'
//         ? sortByPriority(watchedPlaces, myUid!, partnerUid!)
//         : sortByPriority(
//             watchedPlaces.where((p) => p.categoryGroupName == selectedCategory).toList(),
//             myUid!,
//             partnerUid!,
//           );
//
//
//     print('필터드 플레이스 ===> $filteredPlaces');
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: false,
//         backgroundColor: Colors.white,
//         title: const Text('약속장소'),
//       ),
//       body: DecoratedBox(
//         decoration: const BoxDecoration(color: Colors.white),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               _buildCategoryTabs2(),
//               // const Divider(
//               //   height: 0.001,
//               //   color: Color(0xFFB4B4B4),
//               //   thickness: 0.5,
//               //   indent: 16.0,
//               //   endIndent: 16.0,
//               // ),
//               _buildPlaceCountAndEditButton(filteredPlaces),
//               PlaceList(
//                 isEditing: isEditing,
//                 places: filteredPlaces,
//                 selectedIds: selectedIds,
//                 onCheckboxToggled: notifier.toggle,
//                 onEditingChanged: (value) {
//                   setState(() {
//                     isEditing = value;
//                   });
//                 },
//                 myUid: myUid!,
//                 partnerUid: partnerUid!,
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: isEditing ? _buildEditingBottomBar() : const SizedBox.shrink(),
//       floatingActionButton: isEditing
//           ? const SizedBox.shrink()
//           : FloatingActionButton(
//         backgroundColor: PRIMARY_COLOR,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
//         onPressed: () => context.push('/datePicker'),
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
//
//   Widget _buildCategoryTabs() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: categories.map((category) {
//           return TextButton(
//             onPressed: () => setState(() => selectedCategory = category),
//             child: Text(category, style: categoryTextStyle(category)),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   Widget _buildCategoryTabs2() {
//     return SizedBox(
//       height: 44,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 12.0),
//         itemCount: categories.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 10),
//         itemBuilder: (context, index) {
//           final category = categories[index];
//           return ChoiceChip(
//             label: Text(category),
//             selected: category == selectedCategory,
//             onSelected: (_) => setState(() => selectedCategory = category),
//             selectedColor: PRIMARY_COLOR.withOpacity(0.2),
//             backgroundColor: Colors.grey[200],
//             labelStyle: categoryTextStyle(category),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildPlaceCountAndEditButton(List<Place> filteredPlaces) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             'total ${filteredPlaces.length}',
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
//           ),
//           TextButton(
//             onPressed: () => setState(() => isEditing = true),
//             style: TextButton.styleFrom(
//               minimumSize: Size.zero,
//               padding: EdgeInsets.zero,
//               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//             ),
//             child: const Text(
//               '편집',
//               style: TextStyle(color: Colors.grey, fontSize: 12.0),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEditingBottomBar() {
//     return Container(
//       color: PRIMARY_COLOR,
//       padding: const EdgeInsets.all(10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           TextButton.icon(
//             onPressed: () {
//               setState(() {
//                 isEditing = false;
//                 // resetCheckboxes();
//               });
//               ref.read(selectedPlaceIdsProvider.notifier).clear(); // 체크 초기화
//             },
//             icon: const Icon(Icons.cancel, color: Colors.white),
//             label: const Text('취소', style: TextStyle(color: Colors.white)),
//           ),
//           TextButton.icon(
//             onPressed: () {
//               // 삭제 기능은 추후 구현
//             },
//             icon: const Icon(Icons.delete, color: Colors.white),
//             label: const Text('삭제', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
// }
