import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension EmptySpace on num {
  SizedBox get height => SizedBox (height: toDouble().h);
  SizedBox get width => SizedBox (width: toDouble().w);
}