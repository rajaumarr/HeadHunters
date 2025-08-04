import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:head_hunter/models/auth-model.dart';
import 'package:head_hunter/providers/sign-up-provider.dart';
import 'package:head_hunter/services/auth-services.dart';
import 'package:head_hunter/utils/constants/app-assets.dart';
import 'package:head_hunter/utils/constants/fonts.dart';
import 'package:head_hunter/utils/extensions/sizebox.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/colors.dart';
import '../../utils/customWidgets/my-text.dart';
import '../../utils/customWidgets/round-button.dart';
import '../../utils/customWidgets/symetric-padding.dart';
import '../../utils/customWidgets/text-field.dart';
import '../../utils/extensions/global-functions.dart';
import '../../utils/routes/routes-name.dart';
import '../../utils/save-account-type.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {



  bool isObscure=true;
  bool isRemember=true;
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<SignUpProvider>(context,listen: false);
    return Scaffold(
      backgroundColor: whiteColor,
      resizeToAvoidBottomInset: false,
      body: SymmetricPadding(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              50.height,

              Center(child: MyText(text: "Sign In",size: 32.sp,fontWeight: FontWeight.w600,color: primaryColor,)),
              5.height,
              Center(
                child: MyText(text: "Hi! Welcome, Head Hunters",
                  fontFamily: AppFonts.poppins,
                  size: 13.sp,fontWeight: FontWeight.w400,color: blackColor.withOpacity(0.7),),
              ),
              50.height,

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
              // Row(
              //   children: [
              //     Checkbox(
              //       materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
              //         activeColor: primaryColor,
              //         shape: const CircleBorder(
              //
              //         ),
              //         value: isRemember, onChanged: (v){
              //           setState(() {
              //             isRemember=!isRemember;
              //           });
              //     }),
              //     MyText(text: "Remember me",color: primaryColor,size: 14.sp,fontFamily: AppFonts.poppins,),
              //   ],
              // ),
              20.height,
              RoundButton(
                  isLoad: true,
                  title: "Sign In", onTap: (){
                if(
                    emailController.text.isEmpty||
                    passwordController.text.isEmpty){
                  showSnackbar(context, "Missing email or password",color: redColor);
                  return;
                }

                var model=AuthModel(email: emailController.text.trim(), password: passwordController.text.trim());
                AuthServices.loginUser(model, context);

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
                // await AuthServices.signOutUser(context);
               User? user=  await AuthServices.signInWithGoogle();
               customPrint("user============================$user");
               DocumentSnapshot data=await FirebaseFirestore.instance.collection('job-seekers').doc(user!.uid).get();
               if(data.exists){
                 await setUserAccountType(RoleTypes.jobSeeker);

                 Navigator.pushNamedAndRemoveUntil(context, RoutesNames.bottomNav, (route) => false,);
               }else {
                 DocumentSnapshot data=await FirebaseFirestore.instance.collection('company').doc(user!.uid).get();
                 if(data.exists){
                   await setUserAccountType(RoleTypes.company);

                   Navigator.pushNamedAndRemoveUntil(context, RoutesNames.companyBottomNav, (route) => false,);
                 } else{
                   showSnackbar(context, "Please create account first. Then you can use your google account to login",color: redColor,duration: Duration(seconds: 3));
                 await  AuthServices.deleteCurrentUser();
                 }
               }
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
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(text: "Don't have an account? ",fontWeight: FontWeight.w400,size: 14.sp,),
                  InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, RoutesNames.chooseView);
                      },
                      child: MyText(text: "Sign Up",fontWeight: FontWeight.w800,size: 14.sp,color: primaryColor,)),
                ],
              ),
              20.height
            ],
          ),
        ),
      ),

    );
  }
}
