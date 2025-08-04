import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext{

  MediaQueryData get mediaQuery=>MediaQuery.of(this);

  double get screenWidth=>mediaQuery.size.width;
  double get screenHeight=>mediaQuery.size.height;
}