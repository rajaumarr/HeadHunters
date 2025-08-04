import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';

class MyText extends StatelessWidget {
  final String text;
  final TextAlign? textAlignment;
  final double? size;
  final dynamic textDecoration;
  final FontWeight? fontWeight;
  final Color? color;
  final int? maxLine;
  final String? fontFamily;
  final TextOverflow? overflow;
  final double? lineHeight;

  const MyText(
      {super.key,
      required this.text,
      this.textAlignment,
      this.size,
      this.textDecoration,
      this.fontWeight,
      this.color,
      this.maxLine,
      this.fontFamily,
      this.overflow,
      this.lineHeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          height: lineHeight ?? 0,
          color: color ?? blackColor,
          decoration: textDecoration,
          decorationColor: primaryColor,
          fontSize: size ?? 15.sp,
          overflow: overflow ?? TextOverflow.ellipsis,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: fontFamily ?? AppFonts.monserrat),
      textAlign: textAlignment,
    );
  }
}
