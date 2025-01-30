import 'package:flutter/material.dart';
import 'package:my_couple_app/core/constants/colors.dart';
import 'package:my_couple_app/core/ui/component/custom_button.dart';
import 'package:my_couple_app/core/ui/component/custom_calendar.dart';
import 'package:my_couple_app/ui/place/place_add_screen.dart';

class DatepickerScreen extends StatefulWidget {
  const DatepickerScreen({super.key});

  @override
  State<DatepickerScreen> createState() => _DatepickerScreenState();
}

class _DatepickerScreenState extends State<DatepickerScreen> {
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('날짜선택'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomCalendar(
            selectedDay: selectedDay,
            focusedDay: focusedDay,
            onDaySelected: onDaySelected,
          ),
          Text(
            '방문할 날짜를 선택 하세요!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: PRIMARY_COLOR
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PlaceAddScreen()));
                },
                backgroundColor: PRIMARY_COLOR,
                textColor: Colors.white,
                buttonText: "${focusedDay.month}월 ${focusedDay.day}일 선택"),
          )
        ],
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
