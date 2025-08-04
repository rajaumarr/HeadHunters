import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier{

  String _selectedType=RoleTypes.jobSeeker;
  String get selectedType=>_selectedType;

  void changeType(String t){
    _selectedType=t;
    notifyListeners();
  }
}

class RoleTypes{
  static const String jobSeeker='JOB SEEKERS';
  static const String company='COMPANY';
}