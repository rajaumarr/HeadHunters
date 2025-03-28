import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:head_hunter/models/auth-model.dart';
import 'package:head_hunter/models/seeker-model.dart';
import 'package:head_hunter/providers/sign-up-provider.dart';
import 'package:head_hunter/services/auth-services.dart';
import 'package:head_hunter/services/job-services.dart';
import 'package:head_hunter/utils/constants/app-assets.dart';
import 'package:head_hunter/utils/constants/fonts.dart';
import 'package:head_hunter/utils/extensions/global-functions.dart';
import 'package:head_hunter/utils/extensions/sizebox.dart';
import 'package:head_hunter/utils/save-account-type.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/seeker-services.dart';
import '../../utils/constants/colors.dart';
import '../../utils/customWidgets/my-text.dart';
import '../../utils/customWidgets/round-button.dart';
import '../../utils/customWidgets/symetric-padding.dart';
import '../../utils/customWidgets/text-field.dart';
import '../../utils/routes/routes-name.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {


  final userNameController=TextEditingController();
  final ageController=TextEditingController();
  final genderController=TextEditingController();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  bool isObscure=true;
  File? image;
  final _picker = ImagePicker();
  Future getImage({required source}) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      image = File(pickedFile.path);

      setState(() {});
    } else {}
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: whiteColor,
      body: SymmetricPadding(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                50.height,

                Center(child: MyText(text: "Sign Up",size: 32.sp,fontWeight: FontWeight.w600,color: primaryColor,)),
                5.height,
                Center(
                  child: MyText(text: "Create a new account by filling these fields",
                    fontFamily: AppFonts.poppins,
                    size: 13.sp,fontWeight: FontWeight.w400,color: blackColor.withOpacity(0.7),),
                ),
                 50.height,
                GestureDetector(
                  onTap: () => getImage(source: ImageSource.gallery),
                  child: Center(
                    child: Container(
                      height: 150.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        border: Border.all(style: BorderStyle.solid, color: blackColor),
                        shape: BoxShape.circle,
                        image: image != null
                            ? DecorationImage(
                          image: FileImage(image!),
                          fit: BoxFit.cover,
                        )

                            : null,
                      ),
                      child: image == null
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 34.sp),
                          MyText(
                            text: "Upload Image",
                            size: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      )
                          : null,
                    ),
                  ),
                ),
                 50.height,
                 MyText(text: "Username",fontWeight: FontWeight.w400,size: 14.sp),
                 5.height,
                 CustomTextFiled(
                   controller: userNameController,
                  hintText: "Your username",
                  isShowPrefixImage: false,
                  isShowPrefixIcon: false,
                  isFilled: true,
                  isBorder: true,
                  borderRadius: 10.r,

                ),

                15.height,
                MyText(text: "Age",fontWeight: FontWeight.w400,size: 14.sp),
                5.height,
                CustomTextFiled(
                  controller: ageController,
                  hintText: "Your Age",
                  isShowPrefixImage: false,
                  isShowPrefixIcon: false,
                  isFilled: true,
                  isBorder: true,
                  borderRadius: 10.r,
                  keyboardType: TextInputType.number,

                ),
                15.height,
                MyText(text: "Gender",fontWeight: FontWeight.w400,size: 14.sp),
                5.height,
                CustomTextFiled(
                  controller: genderController,
                  hintText: "Your Gender",
                  keyboardType: TextInputType.text,
                  isShowPrefixImage: false,
                  isShowPrefixIcon: false,
                  isFilled: true,
                  isBorder: true,
                  borderRadius: 10.r,
                ),
                15.height,
                MyText(text: "Email",fontWeight: FontWeight.w400,size: 14.sp),
                5.height,
                CustomTextFiled(
                  controller: emailController,
                  hintText: "example@gmail",
                  isShowPrefixImage: false,
                  isShowPrefixIcon: false,
                  isFilled: true,
                  isBorder: true,
                  borderRadius: 10.r,
                ),
                15.height,
                MyText(text: "Password",fontWeight: FontWeight.w400,size: 14.sp),
                5.height,
                CustomTextFiled(
                  controller: passwordController,
                  hintText: "Your Password",
                  isShowPrefixImage: false,
                  isShowPrefixIcon: false,
                  isFilled: true,
                  isBorder: true,
                  isObscure: isObscure,
                  isPassword: true,
                  beforePasswordIcon: Icons.visibility_off,
                  afterPasswordIcon: Icons.visibility,
                  passwordFunction: (){
                    setState(() {
                      isObscure=!isObscure;
                    });
                  },
                  borderRadius: 10.r,
                ),
                20.height,
                RoundButton(
                    isLoad: true,
                    title: "Register", onTap: (){
                  if(image==null){
                    showSnackbar(context, "Please select picture",color: redColor);

                    return;
                  }
                      if(userNameController.text.isEmpty||
                          ageController.text.isEmpty||
                          genderController.text.isEmpty||
                          emailController.text.isEmpty||
                          passwordController.text.isEmpty){
                        showSnackbar(context, "Please enter complete detail",color: redColor);
                        return;
                      }
                      if(genderController.text.trim()!='Male'&&
                          genderController.text.trim()!='male'&&
                          genderController.text.trim()!='Female'&&genderController.text.trim()!='female'&&
                          genderController.text.trim()!='Other'&&genderController.text.trim()!='other'){
                        showSnackbar(context, "Please enter correct gender",color: redColor);
                        return;
                      }
                  var model=AuthModel(email: emailController.text.trim(), password: passwordController.text.trim());
                  var seekerModel=SeekerModel(
                      userId: '',
                      userName: userNameController.text.trim(),
                      age: int.parse(ageController.text.toString()),
                      gender: genderController.text.toString(),
                      email: emailController.text.trim().toString(),
                      password: passwordController.text.trim(),
                      imgUrl: '',
                      userRole: RoleTypes.jobSeeker);

                  AuthServices.signUpUser(model, seekerModel, image!,context);
                  // Navigator.pushNamed(context, RoutesNames.bottomNav);
                }),
                20.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: 120.w,
                        child: const Divider()),
                    MyText(text: "Or Continue with",size: 14.sp,color: blackColor.withOpacity(0.7),),
                    SizedBox(
                        width: 120.w,
                        child: const Divider()),
                  ],
                ),
                20.height,
                GestureDetector(
                  onTap: ()async{
                    User? user=await AuthServices.signInWithGoogle();
                    customPrint("user============================$user");
                    DocumentSnapshot data=await FirebaseFirestore.instance.collection('job-seekers').doc(user!.uid).get();
                    if(data.exists){
                      await setUserAccountType(RoleTypes.jobSeeker);
                      Navigator.pushNamedAndRemoveUntil(context, RoutesNames.bottomNav, (route) => false,);
                    }else{
                      var seekerModel=SeekerModel(
                          userId: '',
                          userName: user!.displayName!,
                          age: 20,
                          gender: 'Male',
                          email: user.email!,
                          password: '',
                          imgUrl: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png',
                          userRole: RoleTypes.jobSeeker);

                      UserServices.addUserForGoogle(seekerModel, user.uid, context);
                    }
                    customPrint(user.displayName!);
                  },
                  child: Container(
                    height: 56.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: const Color(0xffDCDEE0)
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppAssets.googleIcon,scale: 1.7,),
                        20.width,
                        MyText(text: "Continue with Google",fontFamily: AppFonts.poppins,fontWeight: FontWeight.w500,
                        size: 16.sp,
                        )
                      ],
                    ),
                  ),
                ),
                20.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(text: "Do you have an account? ",fontWeight: FontWeight.w400,size: 14.sp,),
                    InkWell(
                        onTap: (){
                          Navigator.pushNamedAndRemoveUntil(context, RoutesNames.signInView,(route) => false,);
                        },
                        child: MyText(text: "Sign In",fontWeight: FontWeight.w800,size: 14.sp,color: primaryColor,)),
                  ],
                ),
                20.height
              ],
            ),
          ),
        ),
      ),

    );
  }
}
