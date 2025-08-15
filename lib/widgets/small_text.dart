
import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  String text;
  FontStyle? fontStyle;
  Color? color;
  double? size;
  FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight?? FontWeight.w400,
        fontSize: size ?? 14,
        fontFamily: 'Poppins',

      ),
      textAlign: TextAlign.center,
    );
  }

  SmallText({super.key, 
    required this.text,
    this.color,
    this.size,
    this.fontWeight,
    this.fontStyle
  });
}
