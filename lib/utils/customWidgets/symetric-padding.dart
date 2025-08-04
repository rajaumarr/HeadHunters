import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SymmetricPadding extends StatelessWidget {
  final Widget child;
  const SymmetricPadding({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      child: child,
    );
  }
}
