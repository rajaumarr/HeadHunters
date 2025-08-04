import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:head_hunter/models/job-post-model.dart';
import 'package:head_hunter/services/job-services.dart';
import 'package:head_hunter/utils/constants/colors.dart';
import 'package:head_hunter/utils/customWidgets/round-button.dart';
import 'package:head_hunter/utils/customWidgets/symetric-padding.dart';
import 'package:head_hunter/utils/extensions/global-functions.dart';
import 'package:head_hunter/utils/extensions/sizebox.dart';

import '../../../utils/constants/app-assets.dart';
import '../../../utils/constants/fonts.dart';
import '../../../utils/customWidgets/my-text.dart';
import '../../../utils/customWidgets/text-field.dart';
import '../../../utils/routes/routes-name.dart';

class PostJobView extends StatefulWidget {
  const PostJobView({super.key});

  @override
  State<PostJobView> createState() => _PostJobViewState();
}

class _PostJobViewState extends State<PostJobView> {
  final List<String> tags = [
  ];
  final skillController=TextEditingController();
  final companyNameController=TextEditingController();
  final openJobController=TextEditingController();
  final levelController=TextEditingController();
  final totalSlotsController=TextEditingController();
  final jobDescriptionController=TextEditingController();
  void addSkill(String v){
    tags.add(v);
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SymmetricPadding(child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            100.height,

            Center(child: MyText(text: "Job Detail",size: 32.sp,fontWeight: FontWeight.w600,color: primaryColor,)),
            5.height,
            Center(
              child: MyText(text: "Create a new account by filling these fields",
                fontFamily: AppFonts.poppins,
                size: 13.sp,fontWeight: FontWeight.w400,color: blackColor.withOpacity(0.7),),
            ),
            50.height,

            MyText(text: "Company Name",fontWeight: FontWeight.w400,size: 14.sp),
            5.height,
            CustomTextFiled(
              hintText: "RABIC",
              controller: companyNameController,
              isShowPrefixImage: false,
              isShowPrefixIcon: false,
              isFilled: true,
              isBorder: true,
              borderRadius: 10.r,
            ),
            10.height,
            MyText(text: "Open Job",fontWeight: FontWeight.w400,size: 14.sp),
            5.height,
            CustomTextFiled(
              controller: openJobController,
              hintText: "i.e graphic designer",
              isShowPrefixImage: false,
              isShowPrefixIcon: false,
              isFilled: true,
              isBorder: true,
              borderRadius: 10.r,
            ),
            10.height,
            MyText(text: "Level",fontWeight: FontWeight.w400,size: 14.sp),
            5.height,
            CustomTextFiled(
              controller: levelController,
              hintText: "Beginner",
              isShowPrefixImage: false,
              isShowPrefixIcon: false,
              isFilled: true,
              isBorder: true,
              borderRadius: 10.r,
            ),  10.height,
            MyText(text: "Total Slots",fontWeight: FontWeight.w400,size: 14.sp),
            5.height,
            CustomTextFiled(
              controller:totalSlotsController ,
              hintText: "i.e 10",
              isShowPrefixImage: false,
              keyboardType: TextInputType.number,
              isShowPrefixIcon: false,
              isFilled: true,
              isBorder: true,
              borderRadius: 10.r,
            ),
            10.height,
            MyText(text: "Job Description",fontWeight: FontWeight.w400,size: 14.sp),
            5.height,
            CustomTextFiled(
              controller: jobDescriptionController,
              hintText: "write here........",
              maxLine: 10,
              isShowPrefixImage: false,
              isShowPrefixIcon: false,
              isFilled: true,
              isBorder: true,
              borderRadius: 10.r,
            ),
            10.height,
            MyText(text: "Required Skills",fontWeight: FontWeight.w400,size: 14.sp),
            5.height,
            CustomTextFiled(
              controller: skillController,
              hintText: "Write skill here",
              onSubmit: (v){
                addSkill(v!);
                skillController.clear();
              },

              isShowPrefixImage: false,
              isShowPrefixIcon: false,
              isFilled: true,
              isBorder: true,
              borderRadius: 10.r,
            ),
            5.height,
            Wrap(
              spacing: 8.0, // Horizontal spacing between tags
              runSpacing: 8.0, // Vertical spacing between rows
              children: tags.map((tag) {
                return Chip(
                  color: const WidgetStatePropertyAll(Color(0xffF5F8FA)),
                  label: MyText(
                    text: tag, // Dynamically display tag text
                    fontWeight: FontWeight.w400,
                    size: 13.sp,
                    color: primaryColor,
                  ),);
              }).toList(),
            ),
            20.height,
            RoundButton(
              isLoad: true,
                title: "Post Now", onTap: (){
                  if(companyNameController.text.isEmpty||
                      openJobController.text.isEmpty||
                      levelController.text.isEmpty||
                      totalSlotsController.text.isEmpty||
                      jobDescriptionController.text.isEmpty
                  ){
                    showSnackbar(context, "All fields are required",color: redColor);
                    return;
                  }
                  var model=JobPostModel(
                      jobId: '',
                      companyId: FirebaseAuth.instance.currentUser!.uid,
                      companyName: companyNameController.text.trim(),
                      openJob: openJobController.text.trim(),
                      level: levelController.text.trim(),
                      jobDescription: jobDescriptionController.text.trim(),
                      tags: tags,
                      applicationsId: [],
                      postedTime: DateTime.now(),
                      totalSlots: int.tryParse(totalSlotsController.text.trim()) ?? 0, appliedApplicantsDetail: []);
              showDialog(context: context, builder: (context){
                return  Dialog(
                  backgroundColor: whiteColor,
                  child: ConfirmationPostDialog(
                    postPressed: (){
                      JobServices.addJob(model, context);
                    //  Navigator.pop(context);
                    },
                  ),
                );
              }
              );
            }),
            10.height
          ],
        ),
      )),
    );
  }
}
class ConfirmationPostDialog extends StatelessWidget {
  final VoidCallback postPressed;
  const ConfirmationPostDialog({super.key, required this.postPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        10.height,
        Image.asset(AppAssets.tickIcon,scale: 3,),
        10.height,
        Text("Are you sure to Post?",style: GoogleFonts.kronaOne(
            fontSize: 18.sp,
            color: primaryColor,
            fontWeight: FontWeight.w400
        ),),
        2.height,
        MyText(text: "Click Confirm if you wanna apply",fontFamily: AppFonts.poppins,size: 12.sp,fontWeight: FontWeight.w500,color: const Color(0xff949494),),
        10.height,

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RoundButton(
                width: 140.w,
                textColor: primaryColor,
                bgColor: transparentColor,
                borderColor: primaryColor,
                title: "Cancel", onTap: (){
              Navigator.pop(context);
            }),
            RoundButton(
                width: 140.w,
                title: "Confirm", onTap: postPressed
            ),
          ],
        ),
        10.height,

      ],
    );
  }
}
class PostSuccessDialog extends StatelessWidget {
  const PostSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        10.height,
        Image.asset(AppAssets.tickIcon,scale: 3,),
        10.height,
        Text("Post Successfully!",style: GoogleFonts.kronaOne(
            fontSize: 18.sp,
            color: primaryColor,
            fontWeight: FontWeight.w400
        ),),
        2.height,
        MyText(text: "You have successfully post the job. ",fontFamily: AppFonts.poppins,size: 12.sp,fontWeight: FontWeight.w500,color: const Color(0xff949494),),
        10.height,
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 15.w),
          child: RoundButton(
              title: "Go to Home", onTap: (){
            Navigator.pushNamedAndRemoveUntil(context, RoutesNames.companyBottomNav,(route) => false,);

          }),
        ),
        10.height,

      ],
    );
  }
}
