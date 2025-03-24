import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_couple_app/core/constants/colors.dart';
import 'package:my_couple_app/core/ui/component/custom_button.dart';
import 'package:my_couple_app/core/ui/component/custom_calendar.dart';

import 'package:flutter/cupertino.dart';
import 'package:my_couple_app/data/provider/place/place_provider.dart';

class DatepickerScreen extends ConsumerStatefulWidget {
  const DatepickerScreen({super.key});

  @override
  ConsumerState<DatepickerScreen> createState() => _DatepickerScreenState();
}

class _DatepickerScreenState extends ConsumerState<DatepickerScreen> {
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
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(CupertinoIcons.back)),
        backgroundColor: Colors.white,
        title: Text('날짜선택'),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
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
                  color: PRIMARY_COLOR),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomButton(
                  onPressed: () {
                    ref.read(selectedDateProvider.notifier).state =
                        focusedDay.toString();
                    context.push('/placeAdd');
                  },
                  backgroundColor: PRIMARY_COLOR,
                  textColor: Colors.white,
                  buttonText: "${focusedDay.month}월 ${focusedDay.day}일 선택"),
            )
          ],
        ),
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
