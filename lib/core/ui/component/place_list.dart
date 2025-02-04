import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class PlaceList extends StatefulWidget {
  final bool isEditing;
  final ValueChanged<bool>? onEditingChanged;

  final List<bool>? selectedItems;
  final ValueChanged<int>? onCheckboxChanged;
  final VoidCallback? onReset;

  const PlaceList({super.key, required this.isEditing, this.onEditingChanged, this.selectedItems, this.onReset, this.onCheckboxChanged});

  @override
  State<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  final List<Map<String, dynamic>> places = [
    {
      'name': '헌스시',
      'address': '부산 해운대구 중동2로 2길',
      'rating': 4.3,
      'image': 'https://picsum.photos/seed/picsum/100/100', // 이미지 경로
    },
    {
      'name': '올리스 카페',
      'address': '부산 해운대구 달맞이길 33',
      'rating': 4.8,
      'image': 'https://picsum.photos/seed/picsum/100/100',
    },
    {
      'name': '빅다방 카페',
      'address': '부산 사상구 빅도로 31',
      'rating': 4.8,
      'image': 'https://picsum.photos/seed/picsum/100/100',
    },
    {
      'name': '빅다방 카페',
      'address': '부산 사상구 빅도로 31',
      'rating': 4.8,
      'image': 'https://picsum.photos/seed/picsum/100/100',
    },
    {
      'name': '빅다방 카페',
      'address': '부산 사상구 빅도로 31',
      'rating': 4.8,
      'image': 'https://picsum.photos/seed/picsum/100/100',
    },
    {
      'name': '빅다방 카페',
      'address': '부산 사상구 빅도로 31',
      'rating': 4.8,
      'image': 'https://picsum.photos/seed/picsum/100/100',
    },
    {
      'name': '빅다방 카페',
      'address': '부산 사상구 빅도로 31',
      'rating': 4.8,
      'image': 'https://picsum.photos/seed/picsum/100/100',
    },
  ];

  // late List<bool> selectedItems =
  //     List.generate(places.length, (index) => false);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            // 내부 ListView 크기 제한
            physics: NeverScrollableScrollPhysics(),
            // 스크롤 비활성화
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // 둥근 모서리 크기
                  ),
                  color: PRIMARY_CARD_COLOR,
                  child: Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.network(place['image'])
                          // Image.asset(
                          //   place['image'], // 이미지 경로
                          //   width: 100,
                          //   height: 100,
                          //   fit: BoxFit.cover,
                          // ),
                          ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              place['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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
                                    color: Colors.yellow[700], size: 16),
                                SizedBox(width: 4),
                                Text(
                                  place['rating'].toString(),
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      widget.isEditing
                          ? Checkbox(
                              value: widget.selectedItems![index],
                              onChanged: (value) {
                                if (widget.onCheckboxChanged != null) {
                                  widget.onCheckboxChanged!(index);
                                }
                              })
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }
}

// ListTile(
// leading: Image.network('https://picsum.photos/seed/picsum/400/300'),
// title: Text(place['name']),
// subtitle: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(place['address']),
// Row(
// children: [
// Icon(Icons.star, color: Colors.yellow[700], size: 16),
// Icon(Icons.star, color: Colors.yellow[700], size: 16),
// Icon(Icons.star, color: Colors.yellow[700], size: 16),
// Icon(Icons.star, color: Colors.yellow[700], size: 16),
// Icon(Icons.star, color: Colors.yellow[700], size: 16),
// ],
// )
// ],
// ),
// trailing: Checkbox(value: selectedItems[index], onChanged: (value){
// setState(() {
// selectedItems[index] = value ?? false;
// });
// }),
// )
