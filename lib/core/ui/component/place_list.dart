import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class PlaceList extends StatelessWidget {
  final bool isEditing;
  final ValueChanged<bool>? onEditingChanged;
  final List<Map<String, dynamic>> places;
  final List<bool>? selectedItems;
  final ValueChanged<int>? onCheckboxChanged;
  final VoidCallback? onReset;

  const PlaceList(
      {super.key,
      required this.isEditing,
      this.onEditingChanged,
      this.selectedItems,
      this.onReset,
      this.onCheckboxChanged,
      required this.places});

  // final List<Map<String, dynamic>> places = [
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  place['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Text(
                                    place['category'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                )
                              ],
                            ),
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
                      isEditing
                          ? Checkbox(
                              value: selectedItems![index],
                              onChanged: (value) {
                                if (onCheckboxChanged != null) {
                                  onCheckboxChanged!(index);
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
