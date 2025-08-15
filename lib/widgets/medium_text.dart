import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MediumText extends StatelessWidget {
  String text;
  Color? color;
  double? size;
  FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight?? FontWeight.w600,
        fontSize: size ?? 14.sp,
        fontFamily: 'Poppins',
        color: color ?? Colors.black,
      ),
    );
  }

  MediumText({super.key, 
    required this.text,
    this.color,
    this.size,
    this.fontWeight, required ,
  });
}
