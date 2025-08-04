
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:head_hunter/models/company-model.dart';
import 'package:head_hunter/models/seeker-model.dart';
import 'package:head_hunter/providers/sign-up-provider.dart';
import 'package:head_hunter/services/company-services.dart';
import 'package:head_hunter/services/seeker-services.dart';
import 'package:head_hunter/utils/routes/routes-name.dart';
import 'package:head_hunter/view/auth/choose-view.dart';
import 'package:head_hunter/view/auth/sign-in-view.dart';

import 'package:provider/provider.dart';

import '../models/auth-model.dart';

import '../models/change-password-model.dart';
import '../providers/loading-provider.dart';
import '../utils/constants/colors.dart';
import '../utils/extensions/global-functions.dart';
import '../utils/save-account-type.dart';

class AuthServices {
  static final _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static Future<void> signUpUser(

      AuthModel loginModel,
      SeekerModel model,
      File file,
      BuildContext context) async {
    final loadingProvider =
    Provider.of<LoadingProvider>(context, listen: false);

    try {
      loadingProvider.setLoading(true);

      UserCredential v = await _auth.createUserWithEmailAndPassword(
          email: loginModel.email,
          password: loginModel.password
      );
     // v.user!.sendEmailVerification();
      if(context.mounted){
        showSnackbar(context, "User created",color: greenColor);
        UserServices.addUser(model,  v.user!.uid, file,context);
      }

      loadingProvider.setLoading(false);


      if(context.mounted){
      }
    } on FirebaseAuthException catch (e) {
      loadingProvider.setLoading(false);
      if(context.mounted){
        showSnackbar(context, e.code,color: redColor);

      }

      customPrint(e.code);

    } catch (e) {
      loadingProvider.setLoading(false);
      customPrint(e.toString());
    }
  }
  static Future<void> signUpCompany(

      AuthModel loginModel,
      CompanyModel model,
      File file,
      BuildContext context) async {
    final loadingProvider =
    Provider.of<LoadingProvider>(context, listen: false);

    try {
      loadingProvider.setLoading(true);

      UserCredential v = await _auth.createUserWithEmailAndPassword(
          email: loginModel.email,
          password: loginModel.password
      );
     // v.user!.sendEmailVerification();
      if(context.mounted){
        showSnackbar(context, "Company created",color: greenColor);
        CompanyServices.addCompany(model,  v.user!.uid, file,context);
      }

      loadingProvider.setLoading(false);


      if(context.mounted){
      }
    } on FirebaseAuthException catch (e) {
      loadingProvider.setLoading(false);
      if(context.mounted){
        showSnackbar(context, e.code,color: redColor);

      }

      customPrint(e.code);

    } catch (e) {
      loadingProvider.setLoading(false);
      customPrint(e.toString());
    }
  }


  static Future<void> loginUser(AuthModel loginUserModel, BuildContext context) async {
    final loadingProvider =
    Provider.of<LoadingProvider>(context, listen: false);
    try {
      loadingProvider.setLoading(true);

      UserCredential value = await _auth.signInWithEmailAndPassword(
          email: loginUserModel.email,
          password: loginUserModel.password
      );
      final userId = value.user!.uid;

      String userType=await UserServices.getUserType(userId);
      setUserAccountType(userType);

      if(userType==RoleTypes.jobSeeker){
        if(context.mounted){
          Navigator.pushNamedAndRemoveUntil(context, RoutesNames.bottomNav, (route) => false,);

        }
      }else if(userType==RoleTypes.company){
        if(context.mounted){
        Navigator.pushNamedAndRemoveUntil(context, RoutesNames.companyBottomNav, (route) => false,);

      }
      }else{
        if(context.mounted){
          showSnackbar(context, "Account doesn't exit",color: redColor);
        }

        _auth.signOut();
      }
      loadingProvider.setLoading(false);


    } on FirebaseAuthException catch (e) {
      loadingProvider.setLoading(false);
      if(context.mounted){
        showSnackbar(context, e.code,color: redColor);
      }

      customPrint(e.code);

    } catch (e) {
      loadingProvider.setLoading(false);
      customPrint(e.toString());
    }
  }
  static Future<void> changePassword(ChangePasswordModel changePasswordModel, BuildContext context) async {
    final backendProvider =
    Provider.of<LoadingProvider>(context, listen: false);

    User? user = _auth.currentUser;
    AuthCredential credential = EmailAuthProvider.credential(
        email: changePasswordModel.email,
        password: changePasswordModel.oldPassword);

    ///verify current password
    try {
      backendProvider.setLoading(true);
      await user?.reauthenticateWithCredential(credential).then((value) async {
        customPrint("Password verified");

        try {
          await user
              .updatePassword(changePasswordModel.newPassword)
              .then((value) {
            if(context.mounted){
              showSnackbar(context, "Password updated Successfully",color: greenColor);
            }

            customPrint("Password Updated");
          }).onError((error, stackTrace) {
            backendProvider.setLoading(false);
            customPrint(error.toString());
          });
        } on FirebaseAuthException catch (e) {
          backendProvider.setLoading(false);  if(context.mounted){
            showSnackbar(context, e.code,color: redColor);
          }
          customPrint(e.toString());
        }
        backendProvider.setLoading(false);

      }).onError((error, stackTrace) {
        backendProvider.setLoading(false);
        if(error.toString()=='[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.'){
          if(context.mounted){
            showSnackbar(context, "Invalid old password",color: redColor);
          }

        }
        customPrint("message $error");
        customPrint(error.toString());
      });
    }on FirebaseException catch (e) {
      backendProvider.setLoading(false);
      customPrint("message $e");
      customPrint(e.toString());
    }
  }
  static Future<void> changePas(String newPassword, BuildContext context) async {
    final backendProvider =
    Provider.of<LoadingProvider>(context, listen: false);

    User? user = _auth.currentUser;

    try {
      await user?.updatePassword(newPassword)
          .then((value) {
        if(context.mounted){
          showSnackbar(context, "Password updated Successfully",color: greenColor);
        }

        customPrint("Password Updated");
      }).onError((error, stackTrace) {
        backendProvider.setLoading(false);
        customPrint(error.toString());
      });
    } on FirebaseAuthException catch (e) {
      backendProvider.setLoading(false);  if(context.mounted){
        showSnackbar(context, e.code,color: redColor);
      }
      customPrint(e.toString());
    }
    backendProvider.setLoading(false);
  }

  static Future<bool> deleteCurrentUser() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        _googleSignIn.signOut();
        customPrint("User successfully deleted from Firebase Auth.");
        return true;
      } else {
        customPrint("No user is currently signed in.");
        return false;
      }
    } catch (e) {
      customPrint("Error deleting user: $e");
      return false;
    }
  }
  static Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      customPrint("Credential=========================$credential");
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      customPrint(e.toString());
      return null;
    }
  }
  static Future<bool> checkIfRegisteredWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return false; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Check if user is new or already registered
      bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? true;

      // If the user is new, sign them out immediately
      if (isNewUser) {
        await _auth.signOut();
        await _googleSignIn.signOut();
        customPrint("User is not registered.");
        return false;
      } else {
        customPrint("User is already registered.");
        return true;
      }
    } catch (e) {
      customPrint(e.toString());
      return false;
    }
  }



  static Future<void> sendResetPassword(BuildContext context,String email)async{
    final backendProvider = Provider.of<LoadingProvider>(context, listen: false);
    backendProvider.setLoading(true);
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value){
      backendProvider.setLoading(false);
    }).onError((error,e){
      backendProvider.setLoading(false);

    });
  }
  static Future<void> signOutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then((value) async{
    await _googleSignIn.signOut();
      if(context.mounted){
        removeUserAccountType();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const SignInView()),(route) => false);
        showSnackbar(context, "Log out successfully",color: greenColor);
      }
      customPrint("Log out successfully");
    }).onError((error, stackTrace) {
      customPrint(error.toString());
    });
  }
}
