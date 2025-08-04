import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:head_hunter/models/seeker-model.dart';
import 'package:head_hunter/providers/sign-up-provider.dart';
import 'package:head_hunter/utils/routes/routes-name.dart';
import 'package:provider/provider.dart';

import '../providers/loading-provider.dart';
import '../utils/extensions/global-functions.dart';
import '../utils/save-account-type.dart';

class UserServices{
  static var auth=FirebaseAuth.instance;
  static var currentUser=auth.currentUser!.uid;
  static final _storage=FirebaseStorage.instance;
  static final _usersCollection=FirebaseFirestore.instance.collection('job-seekers');


  static Future<String>uploadProfile(File file)async{
    final ref=_storage.ref("seeker/${file.hashCode}");
    firebase_storage.SettableMetadata metadata =
    firebase_storage.SettableMetadata(contentType: 'image/jpeg');
    final uploadTask=ref.putFile(file,metadata);
    final snapshot=await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }



  static Future<void> addUser(SeekerModel model,String userId,File file,BuildContext context)async{
    final backendProvider=Provider.of<LoadingProvider>(context,listen: false);
    final signUpProvider=Provider.of<SignUpProvider>(context,listen: false);

    try{
      backendProvider.setLoading(true);
      _usersCollection.doc(userId).set(model.toMap()).then((value)async{
        String imgUrl=await uploadProfile(file);
       await updateUser(userId, {
         'userId':userId,
         'imgUrl':imgUrl
       });

        backendProvider.setLoading(false);
        if(context.mounted){
          setUserAccountType(signUpProvider.selectedType);

          navigateUser(context, signUpProvider.selectedType);

        }

        customPrint("User Added");
      });
    }catch(e){
      backendProvider.setLoading(false);
      customPrint(e.toString());
    }
  }  static Future<void> addUserForGoogle(SeekerModel model,String userId,BuildContext context)async{
    final backendProvider=Provider.of<LoadingProvider>(context,listen: false);
    final signUpProvider=Provider.of<SignUpProvider>(context,listen: false);

    try{
      backendProvider.setLoading(true);
      _usersCollection.doc(userId).set(model.toMap()).then((value)async{
        updateUser(userId, {'userId':userId});

        backendProvider.setLoading(false);
        if(context.mounted){
          setUserAccountType(signUpProvider.selectedType);

          navigateUser(context, signUpProvider.selectedType);

        }

        customPrint("User Added");
      });
    }catch(e){
      backendProvider.setLoading(false);
      customPrint(e.toString());
    }
  }
  static Future<void> updateUser(String userId,Map<String,dynamic>map)async{
    try{
      _usersCollection.doc(userId).update(map).then((value){
        customPrint('User updated');
      });
    }catch(e){
      customPrint(e.toString());
    }
  }


  static Stream<List<SeekerModel>> fetchAllUserStream() {
    return _usersCollection
        .snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          return SeekerModel.fromDoc(doc);
        }
        return null;
      }).where((data) => data != null).cast<SeekerModel>().toList();
    });
  }
  static Future<List<SeekerModel>> fetchAllUserOnce() async {
    try {
      QuerySnapshot snapshot = await _usersCollection.get();
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          return SeekerModel.fromDoc(doc);
        }
        return null;
      }).where((data) => data != null).cast<SeekerModel>().toList();
    } catch (e) {
      customPrint("Error fetching users: $e");
      return [];
    }
  }
  static Future<List<SeekerModel>> fetchAllUserForProperty(String type) async {
    try {
      QuerySnapshot snapshot = await _usersCollection.where('userType',isEqualTo: type).where('userId',isNotEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          return SeekerModel.fromDoc(doc);
        }
        return null;
      }).where((dentist) => dentist != null).cast<SeekerModel>().toList();
    } catch (e) {
      customPrint("Error fetching users: $e");
      return [];
    }
  }
  static Future<SeekerModel?>fetchUserData(String id)async{
    DocumentSnapshot data=await _usersCollection.doc(id).get();
    if(data.exists){
      return SeekerModel.fromDoc(data);
    }
    return null;
  }
  static Stream<SeekerModel?> fetchUserStream(String id){
    return _usersCollection.doc(id).snapshots().map((data){
      if(data.exists){
        return SeekerModel.fromDoc(data);
      }else {
        return null;
      }
    });
  }


  static Future<String>getUserDeviceId(String userId)async{
    final data=await _usersCollection.doc(userId).get();
    String deviceId=data['deviceId'];
    return deviceId;
  }
  static Future<String>getUserType(String userId)async{
    final data=await _usersCollection.doc(userId).get();
    if (data.exists){
      String deviceId=data['userRole'];

      return deviceId;
    }
    else{
      String deviceId=RoleTypes.company;
      return deviceId;
    }

  }

  static  navigateUser(BuildContext context,String userType){
    if(userType==RoleTypes.jobSeeker){
      Navigator.pushNamedAndRemoveUntil(context, RoutesNames.bottomNav, (route) => false);
    }else if(userType==RoleTypes.company){
      Navigator.pushNamedAndRemoveUntil(context, RoutesNames.companyBottomNav, (route) => false);

    }else{
      Navigator.pushNamedAndRemoveUntil(context, RoutesNames.signInView, (route) => false);

    }
  }
}