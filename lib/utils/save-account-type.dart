import 'package:shared_preferences/shared_preferences.dart';

import 'extensions/global-functions.dart';

Future<void> setUserAccountType(String type)async{
  final sp=await SharedPreferences.getInstance();
  await sp.setString('accountType', type).then((v){
    customPrint("Account type saved");
  }).onError((err,e){
    customPrint("Error white saving account type  $err");
  });
}
Future<void> removeUserAccountType()async{
  final sp=await SharedPreferences.getInstance();
  await sp.setBool('accountType', false).then((v){
    customPrint("Account type removed");
  }).onError((err,e){
    customPrint("Error white removing account type $err");
  });
}

Future<String> getUserAccountType()async{
  final sp=await SharedPreferences.getInstance();
  final token= sp.getString('accountType')?? '';
  return token;
}