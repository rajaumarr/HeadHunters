import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:head_hunter/main.dart';
import 'package:head_hunter/providers/sign-up-provider.dart';
import 'package:head_hunter/utils/constants/app-assets.dart';
import 'package:head_hunter/utils/constants/colors.dart';
import 'package:head_hunter/utils/constants/fonts.dart';
import 'package:head_hunter/utils/customWidgets/my-text.dart';
import 'package:head_hunter/utils/customWidgets/round-button.dart';
import 'package:head_hunter/utils/customWidgets/symetric-padding.dart';
import 'package:head_hunter/utils/extensions/sizebox.dart';
import 'package:head_hunter/utils/routes/routes-name.dart';
import 'package:provider/provider.dart';

class ChooseView extends StatelessWidget {
  const ChooseView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<SignUpProvider>(context,listen: false);

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(child: SymmetricPadding(
          child: Column(
        children: [
          80.height,
          Center(
              child: MyText(
                  text: "Continue As",
                  size: 32.sp,
                  fontWeight: FontWeight.w600,
                  color: primaryColor)),
          MyText(
            text: "Mauris urna velit, congue et aliquam non, ",
            size: 13.sp,
            fontWeight: FontWeight.w400,
            color: blackColor.withOpacity(0.7),
            fontFamily: AppFonts.poppins,
          ),
          30.height,

          Consumer<SignUpProvider>(builder: (context,provider,child){
            return GestureDetector(
              onTap: (){
                provider.changeType(RoleTypes.jobSeeker);
              },
              child: Container(
                height: 84.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color(0xffF9F9F9),
                    borderRadius: BorderRadius.circular(3.r),
                    border: Border.all(color: const Color(0xffE7E7E7)),
                    gradient: provider.selectedType==RoleTypes.jobSeeker?

                    const LinearGradient(colors: [
                      gradientColorOne,gradientColorTwo
                    ]):null
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 25.h,
                        width: 25.w,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: whiteColor,
                            border: Border.all(color: whiteColor,width: 3)
                        ),
                        child:  Container(
                          height: 20.h,
                          width: 20.w,
                          decoration:  BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xffE7E7E7)),
                            color:provider.selectedType==RoleTypes.jobSeeker? primaryColor:whiteColor,
                          ),
                        ),
                      ),
                      5.width,
                      Image.asset(AppAssets.seekerIcon,scale: 2.5,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyText(text: RoleTypes.jobSeeker,
                            color:provider.selectedType==RoleTypes.jobSeeker? whiteColor:primaryColor,
                            size: 15.sp,
                            fontWeight: FontWeight.w600,),
                          5.height,
                          SizedBox(
                            width: 220.w,
                            child: MyText(
                              overflow: TextOverflow.clip,
                              maxLine: 2,
                              text: "Finding a job here never been easier to than before",

                              color:provider.selectedType==RoleTypes.jobSeeker? whiteColor:blackColor.withOpacity(0.7),size: 12.sp,fontWeight: FontWeight.w400,),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
          30.height,

         Consumer<SignUpProvider>(
             builder: (context,provider,child){
           return  GestureDetector(
             onTap: (){
               provider.changeType(RoleTypes.company);
             },
             child: Container(
               height: 84.h,
               width: double.infinity,
               decoration: BoxDecoration(
                 color: const Color(0xffF9F9F9),
                   borderRadius: BorderRadius.circular(3.r),
                   border: Border.all(color: const Color(0xffE7E7E7)),
                   gradient: provider.selectedType==RoleTypes.company?

                   const LinearGradient(colors: [
                     gradientColorOne,gradientColorTwo
                   ]):null
               ),
               child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 15.0),
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Container(
                       height: 25.h,
                       width: 25.w,
                       decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           color: whiteColor,
                           border: Border.all(color: whiteColor,width: 3)
                       ),
                       child:  Container(
                         height: 20.h,
                         width: 20.w,
                         decoration:  BoxDecoration(
                           shape: BoxShape.circle,
                           border: Border.all(color: const Color(0xffE7E7E7)),
                           color:provider.selectedType==RoleTypes.company? primaryColor:whiteColor,
                         ),
                       ),
                     ),
                     5.width,
                     Image.asset(AppAssets.companyIcon,scale: 2.5,),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         MyText(text: RoleTypes.company,
                           color:provider.selectedType==RoleTypes.company? whiteColor:primaryColor,
                           size: 15.sp,
                           fontWeight: FontWeight.w600,),
                         5.height,
                         SizedBox(
                           width: 220.w,
                           child: MyText(
                             overflow: TextOverflow.clip,
                             maxLine: 2,
                             text: "Let’s recruit your great candidate faster here ",

                             color:provider.selectedType==RoleTypes.company? whiteColor:blackColor.withOpacity(0.7),size: 12.sp,fontWeight: FontWeight.w400,),
                         ),
                       ],
                     ),

                   ],
                 ),
               ),
             ),
           );
         }),
          const Spacer(),
          RoundButton(title: "Next", onTap: (){

            if(provider.selectedType==RoleTypes.company){
              Navigator.pushNamed(context, RoutesNames.companySignUpView);

            }else{
              Navigator.pushNamed(context, RoutesNames.signUpView);

            }                          }),
          20.height,


        ],
      ))),
    );
  }
}
