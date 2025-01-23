import 'package:flutter/material.dart';
import 'package:my_couple_app/component/custom_calendar.dart';
import 'package:my_couple_app/const/colors.dart';
import 'package:my_couple_app/screen/place_add_screen.dart';

class PlaceListScreen extends StatefulWidget {
  const PlaceListScreen({super.key});

  @override
  State<PlaceListScreen> createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends State<PlaceListScreen> {
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();
  final categories = ['전체', '카페', '식당', 'bar', '백화점', '테마파크', '갤러리'];
  final List<Map<String, dynamic>> places = [
    {
      'name': '헌스시',
      'address': '부산 해운대구 중동2로 2길',
      'rating': 4.3,
      'image': 'assets/images/default_background.jpg', // 이미지 경로
    },
    {
      'name': '올리스 카페',
      'address': '부산 해운대구 달맞이길 33',
      'rating': 4.8,
      'image': 'assets/images/default_background.jpg',
      'highlighted': true, // 선택된 아이템
    },
    {
      'name': '디무 커피',
      'address': '부산 기장군 일광읍 512',
      'rating': 4.5,
      'image': 'assets/images/default_background.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('데이트코스'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomCalendar(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              onDaySelected: onDaySelected,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories
                    .map(
                      (category) => TextButton(
                        onPressed: () {},
                        child: Text(
                          category,
                          style: TextStyle(
                            color:
                                category == '전체' ? Colors.black : Colors.grey,
                            fontWeight: category == '전체'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Divider(
              height: 0.001,
              color: Color(0xFFB4B4B4),
              thickness: 0.5,
              indent: 16.0,
              endIndent: 16.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL ${places.length}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: Text(
                      '편집',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // 둥근 모서리 크기
                      ),
                      color: PRIMARY_CARD_COLOR,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.asset(
                              place['image'], // 이미지 경로
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          Column(
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
                          )
                        ],
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PlaceAddScreen()));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // 1. 선택한 날짜(=selectedDay)를 state에서 관리 하도록함
    print(selectedDay);
    setState(() {
      this.selectedDay = selectedDay; // 2.데이터값을 바꿔주기때문에 다시 빌드됨
      this.focusedDay = selectedDay;
    });
  }
}
