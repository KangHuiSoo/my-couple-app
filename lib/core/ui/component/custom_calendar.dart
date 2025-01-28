import 'package:flutter/material.dart';
import 'package:my_couple_app/core/constants/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatelessWidget {
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final OnDaySelected? onDaySelected;

  const CustomCalendar({
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
    Key? key,
  }) : super(key: key);

  // DateTime? selectedDay;
  @override
  Widget build(BuildContext context) {
    final defaultBoxDeco = BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      // color: PRIMARY_COLOR,
      // color: Colors.white70,
    );

    final defaultTextStyle = TextStyle(
        color: Colors.grey[600], fontWeight: FontWeight.w700, fontSize: 12.0);

    return Container(
      color: Color(0xFFF3F8F9),
      child: TableCalendar(
        locale: 'ko_KR',
        focusedDay: focusedDay,
        firstDay: DateTime(1800),
        lastDay: DateTime(3000),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16.0,
          ),
        ),
        calendarStyle: CalendarStyle(
          // cellMargin: EdgeInsets.all(2.0), // 셀 간의 간격을 없앰
          // 오늘 날짜 표기 여부
          isTodayHighlighted: false,
          // 평일 스타일 적용
          defaultTextStyle: defaultTextStyle,
          defaultDecoration: defaultBoxDeco,
          // 주말 스타일 적용
          weekendTextStyle: defaultTextStyle,
          weekendDecoration: defaultBoxDeco,
          // 선택된 날짜 스타일 적용
          selectedDecoration: BoxDecoration(
            color: PRIMARY_COLOR,
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
              color: PRIMARY_COLOR,
              width: 1.0,
            ),
          ),
          outsideDecoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          selectedTextStyle: defaultTextStyle.copyWith(
            color: Colors.white,
          ),
        ),
        onDaySelected: onDaySelected,
        selectedDayPredicate: (DateTime date) {
          // 3. 현재 선택된 날짜가 맞는지 비교하여 표시함 true인경우 선택됨
          if (selectedDay == null) {
            return false; // 선택없는 경우 false를 리턴해주었기때문에 처음 실행하면 날짜가 선택되어 있지 않음
          }

          return date.year ==
                  selectedDay!
                      .year && // 선택날짜와의 연,월,일을 비교한후 true를 리턴하면 선택한날짜에 표시가됨
              date.month == selectedDay!.month &&
              date.day == selectedDay!.day;
        },
      ),
    );
  }
}
