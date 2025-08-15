import 'package:flutter/material.dart';

String placeholder_url = "https://phito.be/wp-content/uploads/2020/01/placeholder.png";

var placeholderImageUrl = "https://www.slntechnologies.com/wp-content/uploads/2017/08/ef3-placeholder-image.jpg";
List<BoxShadow> appBoxShadow = [const BoxShadow(blurRadius: 5, color: Color(0x414D5678))];
BoxDecoration roundDecorationWithBorder = BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black26));
BoxDecoration roundDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.white,
    boxShadow: appBoxShadow
);
BoxDecoration fiveRoundDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(4),
    color: Colors.white,
    boxShadow: appBoxShadow
);