import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_couple_app/const/colors.dart';
import 'package:my_couple_app/screen/home_screen.dart';
import 'package:my_couple_app/screen/mypage_screen.dart';
import 'package:my_couple_app/screen/place_list_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    PlaceListScreen(),
    MyPageScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.house), label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.calendar), label: 'Place'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined), label: 'MyPage'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: PRIMARY_COLOR,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
