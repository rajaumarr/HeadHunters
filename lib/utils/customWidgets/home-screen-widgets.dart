import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:head_hunter/utils/constants/colors.dart';
import 'package:head_hunter/utils/customWidgets/my-text.dart';
import 'package:head_hunter/utils/extensions/sizebox.dart';

Widget customLevelAndTags(String level, String type, List<String> tags) {
  return Row(
    children: [
      58.width,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: level,
            color: purpleColor,
            fontWeight: FontWeight.w400,
            size: 14.sp,
          ),
          MyText(
            text: type,
            color: primaryColor,
            fontWeight: FontWeight.w400,
            size: 12.sp,
          ),
          15.height,
          _customTag(tags),
        ],
      ),
    ],
  );
}

Widget companyImageJobTitleCompanyName(
    String imagePath, String jobTitle, String companyName) {
  return Row(
    children: [
      Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
        child: Image.asset(
          imagePath,
          fit: BoxFit.scaleDown,
        ),
      ),
      10.width,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: jobTitle,
            color: primaryColor,
            fontWeight: FontWeight.w400,
            size: 12.sp,
          ),
          MyText(
            text: companyName,
            color: purpleColor,
            fontWeight: FontWeight.w400,
            size: 14.sp,
          ),
        ],
      ),
    ],
  );
}

Widget category(String imagePath) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
    decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(20.r)),
    child: Image.asset(
      imagePath,
      fit: BoxFit.scaleDown,
    ),
  );
}

Widget jobCard(String imagePath, String jobTitle, String companyName,
    String level, String type, List<String> tags) {
  return Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12.r)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        companyImageJobTitleCompanyName(imagePath, jobTitle, companyName),
        10.height,
        const Divider(
          color: borderColor,
        ),
        5.height,
        customLevelAndTags(level, type, tags),
      ],
    ),
  );
}

Widget _customTag(List<String> text) {
  return Row(
    children: [
      for (int i = 0; i < text.length; i++) ...{
        Container(
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
              color: matchTagColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(4.r)),
          child: MyText(
            text: text[i],
            size: 12.sp,
            color: purpleColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        5.width,
      }
    ],
  );
}
