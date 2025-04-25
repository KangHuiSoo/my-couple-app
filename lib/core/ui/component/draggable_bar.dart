import 'package:flutter/material.dart';

class DraggableBar extends StatelessWidget {
  const DraggableBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
