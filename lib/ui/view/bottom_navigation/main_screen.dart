import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:my_couple_app/core/constants/colors.dart';


class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.house), label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.calendar), label: 'Place'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined), label: 'MyPage'),
        ],
        selectedItemColor: PRIMARY_COLOR,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 0) {
            context.go('/home');
          } else if (index == 1) {
            context.go('/placeList');
          } else if (index == 2) {
            context.go('/myPage');
          }
        },
      ),
    );
  }
}
