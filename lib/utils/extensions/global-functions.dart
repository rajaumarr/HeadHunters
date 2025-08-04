import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';


void customPrint(String message){
  debugPrint(message);
}String changeDateFormat(DateTime date) {
  final DateFormat formatter = DateFormat('MMM d,yyyy');
  return formatter.format(date);
}
String dateFormat(DateTime dateTime){
  return DateFormat('d, MMM yyyy').format(dateTime);
}
String timeFormat(DateTime dateTime){
  return DateFormat('hh:mm a').format(dateTime);
}
DateTime convertToDateTime(TimeOfDay time) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, time.hour, time.minute);
}
String capitalizeFirstLetter(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}
String capitalizeEachWord(String text) {
  if (text.isEmpty) {
    return text;
  }

  List<String> words = text.split(' ');

  /// Capitalize the first letter of each word
  List<String> capitalizedWords =
  words.map((word) => capitalizeFirstLetter(word)).toList();

  return capitalizedWords.join(' ');
}
void showSnackbar(BuildContext context, String message, {Duration duration = const Duration(seconds: 2),Color? color=blackColor}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
      backgroundColor:color ,
      clipBehavior: Clip.hardEdge,
      behavior: SnackBarBehavior.floating,
    ),
  );
}