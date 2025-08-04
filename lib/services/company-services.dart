import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:head_hunter/models/company-model.dart';
import 'package:head_hunter/models/seeker-model.dart';
import 'package:head_hunter/providers/sign-up-provider.dart';
import 'package:head_hunter/utils/routes/routes-name.dart';
import 'package:provider/provider.dart';

import '../providers/loading-provider.dart';
import '../utils/extensions/global-functions.dart';
import '../utils/save-account-type.dart';

class CompanyServices{
  static var auth=FirebaseAuth.instance;
  static var currentUser=auth.currentUser!.uid;
  static final _storage=FirebaseStorage.instance;
  static final _companyCollection=FirebaseFirestore.instance.collection('company');


  static Future<String>uploadPicture(File file)async{
    final ref=_storage.ref("company/${file.hashCode}");
    firebase_storage.SettableMetadata metadata =
    firebase_storage.SettableMetadata(contentType: 'image/jpeg');
    final uploadTask=ref.putFile(file,metadata);
    final snapshot=await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }



  static Future<void> addCompany(CompanyModel model,String userId,File? file,BuildContext context)async{
    final backendProvider=Provider.of<LoadingProvider>(context,listen: false);
    final signUpProvider=Provider.of<SignUpProvider>(context,listen: false);

    try{
      backendProvider.setLoading(true);
      _companyCollection.doc(userId).set(model.toMap()).then((value)async{
        String imgUrl=file==null?'': await uploadPicture(file);
        updateCompany(userId, {
          'companyId':userId,
          'imgUrl':imgUrl,

        });

        backendProvider.setLoading(false);
        if(context.mounted){
          setUserAccountType(signUpProvider.selectedType);

          navigateUser(context, signUpProvider.selectedType);

        }

        customPrint("Company Added");
      });
    }catch(e){
      backendProvider.setLoading(false);
      customPrint(e.toString());
    }
  }
  static Future<void> addCompanyForGoogle(CompanyModel model,String userId,BuildContext context)async{
    final backendProvider=Provider.of<LoadingProvider>(context,listen: false);
    final signUpProvider=Provider.of<SignUpProvider>(context,listen: false);

    try{
      backendProvider.setLoading(true);
      _companyCollection.doc(userId).set(model.toMap()).then((value)async{

        updateCompany(userId, {
          'companyId':userId,

        });

        backendProvider.setLoading(false);
        if(context.mounted){
          setUserAccountType(signUpProvider.selectedType);

          navigateUser(context, signUpProvider.selectedType);

        }

        customPrint("Company Added");
      });
    }catch(e){
      backendProvider.setLoading(false);
      customPrint(e.toString());
    }
  }
  static Future<void> updateCompany(String id,Map<String,dynamic>map)async{
    try{
      _companyCollection.doc(id).update(map).then((value){
        customPrint('Company updated');
      });
    }catch(e){
      customPrint(e.toString());
    }
  }



  static Stream<List<CompanyModel>> fetchAllCompanyStream() {
    return _companyCollection
        .snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          return CompanyModel.fromDoc(doc);
        }
        return null;
      }).where((data) => data != null).cast<CompanyModel>().toList();
    });
  }
  static Future<List<CompanyModel>> fetchAllCompanyOnce() async {
    try {
      QuerySnapshot snapshot = await _companyCollection.get();
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          return CompanyModel.fromDoc(doc);
        }
        return null;
      }).where((data) => data != null).cast<CompanyModel>().toList();
    } catch (e) {
      customPrint("Error fetching Company: $e");
      return [];
    }
  }
  static Future<List<CompanyModel>> fetchAllCompanyForProperty(String type) async {
    try {
      QuerySnapshot snapshot = await _companyCollection.where('userType',isEqualTo: type).where('userId',isNotEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          return CompanyModel.fromDoc(doc);
        }
        return null;
      }).where((data) => data != null).cast<CompanyModel>().toList();
    } catch (e) {
      customPrint("Error fetching Company: $e");
      return [];
    }
  }
  static Future<CompanyModel?>fetchCompanyData(String id)async{
    DocumentSnapshot data=await _companyCollection.doc(id).get();
    if(data.exists){
      return CompanyModel.fromDoc(data);
    }
    return null;
  }
  static Stream<CompanyModel?> fetchCompanyStream(String id){
    return _companyCollection.doc(id).snapshots().map((data){
      if(data.exists){
        return CompanyModel.fromDoc(data);
      }else {
        return null;
      }
    });
  }


  static Future<String>getUserType(String userId)async{
    final data=await _companyCollection.doc(userId).get();
    String deviceId=data['userRole'];
    return deviceId;
  }

  static  navigateUser(BuildContext context,String userType){
    if(userType==RoleTypes.jobSeeker){
      Navigator.pushNamedAndRemoveUntil(context, RoutesNames.bottomNav, (route) => false);
    }else if(userType==RoleTypes.company){
      Navigator.pushNamedAndRemoveUntil(context, RoutesNames.companyBottomNav, (route) => false);

    }else{
    }
  }
}