import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_couple_app/core/constants/colors.dart';
import 'package:my_couple_app/features/couple/viewmodel/couple_view_model.dart';

class FirstMetDatePickerScreen extends ConsumerStatefulWidget {
  const FirstMetDatePickerScreen({super.key});

  @override
  ConsumerState<FirstMetDatePickerScreen> createState() => _FirstMetDatePickerScreenState();
}

class _FirstMetDatePickerScreenState extends ConsumerState<FirstMetDatePickerScreen> {
  final List<int> years = List.generate(30, (index) => DateTime.now().year - index);
  final List<int> months = List.generate(12, (index) => index + 1);
  final List<int> days = List.generate(31, (index) => index + 1);

  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF81D0D9);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            // 아이콘
            const Icon(Icons.calendar_today_rounded, size: 50, color: PRIMARY_COLOR),
            const SizedBox(height: 12),
            // 제목
            const Text(
              '우리의 첫 만남은 언제였나요?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: PRIMARY_COLOR,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              '함께한 시간을 기억해볼까요?',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            // Picker 박스
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              height: 180,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPicker(years, (index) {
                    setState(() {
                      selectedYear = years[index];
                    });
                  }, years.indexOf(selectedYear)),
                  _buildPicker(months, (index) {
                    setState(() {
                      selectedMonth = months[index];
                    });
                  }, months.indexOf(selectedMonth)),
                  _buildPicker(days, (index) {
                    setState(() {
                      selectedDay = days[index];
                    });
                  }, days.indexOf(selectedDay)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // 완료 버튼
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                final selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
                final coupleId = ref.read(coupleViewModelProvider).value?.id;

                if(coupleId != null) {
                  await ref.read(coupleViewModelProvider.notifier).updateFirstMetDate(coupleId, selectedDate);
                }
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //   content: Text("선택된 날짜: ${selectedDate.toLocal()}"),
                // ));
              },
              icon: const Icon(Icons.favorite, size: 20, color: Colors.white),
              label: const Text(
                '저장',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPicker(List<int> values, ValueChanged<int> onSelectedItemChanged, int selectedIndex) {
    return Expanded(
      child: CupertinoPicker(
        itemExtent: 36,
        magnification: 1.1,
        squeeze: 1.2,
        diameterRatio: 1.2,
        scrollController: FixedExtentScrollController(initialItem: selectedIndex),
        onSelectedItemChanged: onSelectedItemChanged,
        selectionOverlay: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: PRIMARY_COLOR.withOpacity(0.3), width: 1),
              bottom: BorderSide(color: PRIMARY_COLOR.withOpacity(0.3), width: 1),
            ),
          ),
        ),
        children: values.map((val) {
          return Center(
            child: Text(
              '$val',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          );
        }).toList(),
      ),
    );
  }
}