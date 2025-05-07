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