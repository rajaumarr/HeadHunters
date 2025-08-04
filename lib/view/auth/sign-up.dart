// Full updated code for SignUpView with improved validation and dropdown gender

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
  final userNameController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isObscure = true;
  File? image;
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  String selectedGender = 'Male';

  Future getImage({required source}) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {});
    }
  }

  bool isEmailValid(String email) {
    return RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    ).hasMatch(email);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SymmetricPadding(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  50.height,

                  Center(
                    child: MyText(
                      text: "Sign Up",
                      size: 32.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                  5.height,
                  Center(
                    child: MyText(
                      text: "Create a new account by filling these fields",
                      fontFamily: AppFonts.poppins,
                      size: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: blackColor.withOpacity(0.7),
                    ),
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
                  MyText(text: "Username", fontWeight: FontWeight.w400, size: 14.sp),
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
                  MyText(text: "Age", fontWeight: FontWeight.w400, size: 14.sp),
                  5.height,
                  CustomTextFiled(
                    controller: ageController,
                    hintText: "Your Age",
                    keyboardType: TextInputType.number,
                    isShowPrefixImage: false,
                    isShowPrefixIcon: false,
                    isFilled: true,
                    isBorder: true,
                    borderRadius: 10.r,
                  ),
                  15.height,
                  MyText(text: "Gender", fontWeight: FontWeight.w400, size: 14.sp),
                  5.height,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedGender,
                      underline: const SizedBox(),
                      items: ['Male', 'Female', 'Other'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedGender = newValue!;
                        });
                      },
                    ),
                  ),
                  15.height,
                  MyText(text: "Email", fontWeight: FontWeight.w400, size: 14.sp),
                  5.height,
                  CustomTextFiled(
                    controller: emailController,
                    hintText: "example@gmail.com",
                    isShowPrefixImage: false,
                    isShowPrefixIcon: false,
                    isFilled: true,
                    isBorder: true,
                    borderRadius: 10.r,
                  ),
                  15.height,
                  MyText(text: "Password", fontWeight: FontWeight.w400, size: 14.sp),
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
                    passwordFunction: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    borderRadius: 10.r,
                  ),
                  20.height,
                  RoundButton(
                      isLoad: true,
                      title: "Register",
                      onTap: () {
                        if (image == null) {
                          showSnackbar(context, "Please select picture", color: redColor);
                          return;
                        }

                        if (userNameController.text.isEmpty ||
                            ageController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          showSnackbar(context, "Please enter complete detail", color: redColor);
                          return;
                        }

                        if (!isEmailValid(emailController.text.trim())) {
                          showSnackbar(context, "Please enter a valid email", color: redColor);
                          return;
                        }

                        if (passwordController.text.length < 6) {
                          showSnackbar(context, "Password must be at least 6 characters", color: redColor);
                          return;
                        }

                        int? age = int.tryParse(ageController.text);
                        if (age == null || age < 18 || age > 100) {
                          showSnackbar(context, "Enter a valid age between 18 and 100", color: redColor);
                          return;
                        }

                        var model = AuthModel(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        var seekerModel = SeekerModel(
                          userId: '',
                          userName: userNameController.text.trim(),
                          age: age,
                          gender: selectedGender,
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          imgUrl: '',
                          userRole: RoleTypes.jobSeeker,
                        );

                        AuthServices.signUpUser(model, seekerModel, image!, context);
                      }),

                  // Google sign in and login prompt skipped for brevity (no validation needed there)

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
