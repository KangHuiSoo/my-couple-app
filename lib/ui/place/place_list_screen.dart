import 'package:flutter/material.dart';
import 'package:my_couple_app/core/constants/colors.dart';
import 'package:my_couple_app/core/ui/component/place_list.dart';
import 'package:my_couple_app/ui/place/datepicker_screen.dart';

class PlaceListScreen extends StatefulWidget {
  const PlaceListScreen({super.key});

  @override
  State<PlaceListScreen> createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends State<PlaceListScreen> {
  bool isEditing = false; // 편집 모드 상태
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();
  final categories = ['전체', '카페', '식당', 'bar', '백화점', '테마파크', '갤러리'];
  late List<bool> selectedItems;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedItems = List.generate(7, (_) => false);
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('데이트코스'),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // CustomCalendar(
              //   selectedDay: selectedDay,
              //   focusedDay: focusedDay,
              //   onDaySelected: onDaySelected,
              // ),
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
                  endIndent: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL 5',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isEditing = true;
                        });
                      },
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
              PlaceList(
                  isEditing: isEditing,
                  selectedItems: selectedItems,
                  onCheckboxChanged: toggleCheckbox,
                  onReset: resetCheckboxes,
                  onEditingChanged: (value) {
                    setState(() {
                      isEditing = value;
                    });
                  })
            ],
          ),
        ),
      ),
      bottomNavigationBar: isEditing
          ? Container(
              color: PRIMARY_COLOR,
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        isEditing = false;
                        resetCheckboxes();
                        // widget.onEditingChanged!(false);
                        // selectedItems = [false, false, false];
                      });
                    },
                    icon: Icon(Icons.close),
                    label: Text('취소'),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        // selectedItems =
                        //     List.generate(selectedItems.length, (_) => false);
                      });
                    },
                    icon: Icon(Icons.delete),
                    label: Text('삭제'),
                  ),
                ],
              ),
            )
          : SizedBox.shrink(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DatepickerScreen()));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

// void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//   // 1. 선택한 날짜(=selectedDay)를 state에서 관리 하도록함
//   print(selectedDay);
//   setState(() {
//     this.selectedDay = selectedDay; // 2.데이터값을 바꿔주기때문에 다시 빌드됨
//     this.focusedDay = selectedDay;
//   });
// }
}
