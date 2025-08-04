import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:head_hunter/utils/constants/app-assets.dart';
import 'package:head_hunter/utils/constants/colors.dart';
import 'package:head_hunter/utils/customWidgets/my-text.dart';
import 'package:head_hunter/utils/customWidgets/round-button.dart';
import 'package:head_hunter/utils/extensions/sizebox.dart';
import 'package:head_hunter/utils/routes/routes-name.dart';


class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffDAF2FF),
      body: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              child: Image.asset(AppAssets.mobileIcon,scale: 3,)),
          Positioned(
              left: 0,
              right: 0,
              top: 200,
              child: Image.asset(AppAssets.jobCardIcon,scale: 3,)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 307.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                )
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    10.height,
                RichText(
                text: TextSpan(
                text: 'Your ',
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 37.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Dream job ',
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 37.sp,
                        fontWeight: FontWeight.w600,
                      ),                    ),
                    TextSpan(
                      text: 'is ',
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 37.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),  TextSpan(
                      text: 'waiting for you!',
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 37.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
                    20.height,

                    MyText(
                      overflow: TextOverflow.clip,
                      text: "Mauris urna velit, congue et aliquam non, imperdiet id massa. Etiam commodo ",
                    size: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff767E94),
                    ),
                    30.height,
                    RoundButton(
                        isShowIcon: true,
                        title: "Get Started", onTap: (){
                          Navigator.pushNamed(context, RoutesNames.signInView);
                    })
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
