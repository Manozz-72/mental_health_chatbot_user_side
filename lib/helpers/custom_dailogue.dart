
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDialog {
  static Future<void> showCustomDialog(BuildContext context, Widget content, radius ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular( radius ?? 40.0.sp),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: _buildDialogContent(content,radius),
        );
      },
    );
  }

  static Widget _buildDialogContent( Widget content, radius) {
    return Container(
      padding: EdgeInsets.all(10.0.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: content,
    );
  }
}
