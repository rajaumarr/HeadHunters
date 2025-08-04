import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:head_hunter/services/seeker-services.dart';
import 'package:head_hunter/utils/save-account-type.dart';

import '../../utils/routes/routes-name.dart';

class SplashServices{
  final auth=FirebaseAuth.instance;
  void isLoggedIn(BuildContext context)async{
    if(auth.currentUser!=null){
      String userType=await getUserAccountType();
      UserServices.navigateUser(context, userType);
    }else{
      Timer(const Duration(seconds: 3), () => Navigator.pushNamedAndRemoveUntil(context,RoutesNames.welcomeView,(route) => false,));

    }
  }


}