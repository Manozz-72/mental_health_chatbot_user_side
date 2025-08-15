import 'package:flutter/material.dart';

class Note extends StatelessWidget {
  final String noteText;
  final Color? backgroundColor;
  final Color? textColor;
  final double? textSize;

  const Note({
    super.key,
    required this.noteText,
    this.backgroundColor = Colors.yellow, // Default background color
    this.textColor = Colors.black,       // Default text color
    this.textSize = 14.0,                // Default text size
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        noteText,
        style: TextStyle(
          fontSize: textSize,
          color: textColor,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
