import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_couple_app/features/place/model/place.dart';
import 'package:my_couple_app/features/place/viewmodel/place_view_model.dart';

import '../../constants/colors.dart';

class PlaceList extends ConsumerWidget {
  final bool isEditing;
  final ValueChanged<bool>? onEditingChanged;
  final List<Place> places;
  final Set<String> selectedIds;
  final void Function(String placeId)? onCheckboxToggled;
  final VoidCallback? onReset;

  // ⭐️ 추가: 로그인한 유저 UID와 상대방 UID
  final String myUid;
  final String partnerUid;

  const PlaceList(
      {super.key,
      required this.isEditing,
      this.onEditingChanged,
      required this.selectedIds,
      this.onReset,
      this.onCheckboxToggled,
      required this.places,
      required this.myUid,
      required this.partnerUid});

  // final List<Map<String, dynamic>> places = [
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              final myRating = place.userRatings?[myUid];
              final partnerRating = place.userRatings?[partnerUid];
              final hasBoth = myRating != null && partnerRating != null;
              final average = hasBoth
                  ? ((myRating + partnerRating) / 2).toStringAsFixed(1)
                  : '-';

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
                          child: Image.network(
                              'https://picsum.photos/seed/picsum/100/100')
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
                                Flexible(
                                  child: Text(
                                    place.placeName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Text(
                                    place.categoryGroupName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Text(
                              place.addressName,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("내 평가:",
                                        style: TextStyle(fontSize: 12)),
                                    SizedBox(width: 6),
                                    RatingBar.builder(
                                      initialRating: (myRating ?? 0).toDouble(),
                                      minRating: 1,
                                      maxRating: 5,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemSize: 20,
                                      unratedColor: Colors.grey[300],
                                      itemBuilder: (context, _) =>
                                          Icon(Icons.star, color: Colors.amber),
                                      onRatingUpdate: (rating) {
                                        //TODO : Firestore 업데이트 로직 연결
                                        ref
                                            .read(
                                                placeNotifierProvider.notifier)
                                            .updateUserRating(place.id, myUid,
                                                rating.toInt());
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6.0),
                                Row(
                                  children: [
                                    Icon(Icons.person,
                                        size: 16, color: Colors.grey[500]),
                                    Text(
                                        "상대: ${partnerRating ?? '-'}점",
                                        style: TextStyle(fontSize: 12)),
                                  ],
                                )
                              ],
                            ),
                            if (hasBoth)
                              Padding(
                                padding: EdgeInsets.only(top: 6.0),
                                child: Text(
                                  '⭐ 평균 우선순위: $average점',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.teal),
                                ),
                              )
                          ],
                        ),
                      ),
                      isEditing
                          ? Checkbox(
                              value: selectedIds.contains(place.id),
                              onChanged: (_) =>
                                  onCheckboxToggled?.call(place.id),
                            )
                          : SizedBox.shrink()
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
