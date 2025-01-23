import 'package:flutter/material.dart';
import 'package:my_couple_app/const/colors.dart';


class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  const CustomButton({super.key, required this.onPressed, required this.buttonText, this.backgroundColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width:  double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 16,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
