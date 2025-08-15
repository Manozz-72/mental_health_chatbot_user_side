
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';


class MyCustomButton extends StatelessWidget {
  String text;
  bool loading;
  double? size;
  Callback onTap;
    bool? isRound;
    double? width;
    double? height;
    double? margin;
  Color? buttonColor;
  Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,
      child: Container(
        margin:EdgeInsets.symmetric(horizontal: margin ?? 0,vertical: margin??10.sp),
        alignment: Alignment.center,
        height:height?? 45.sp,
        width: width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: isRound==true?BorderRadius.circular(30.sp):BorderRadius.circular(30.sp),
          color: buttonColor?? const Color(0xff21AF85),
        ),
        child: loading?const CircularProgressIndicator(
          color: Colors.white,
            strokeWidth: 1,
        ):Text(
          text,
          style: TextStyle(fontSize:size ?? 16.sp,
              decoration: TextDecoration.none,
              color: textColor??Colors.white),
        ),
      ),
    );
  }

  MyCustomButton({super.key, 
    required this.text,
    required this.loading,
    this.size,
    required this.onTap,
    this.isRound,
    this.width,
    this.height,
    this.margin,
    this.buttonColor,
    this.textColor,
  });
}
