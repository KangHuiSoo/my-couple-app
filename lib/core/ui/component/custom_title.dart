import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String titleText;
  const CustomTitle({super.key, required this.titleText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 8.0),
      child: Row(
        children: [
          Text(
            titleText,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          Icon(Icons.keyboard_arrow_right)
        ],
      ),
    );
  }
}
