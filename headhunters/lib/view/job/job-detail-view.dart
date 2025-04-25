import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:head_hunter/services/company-services.dart';
import 'package:head_hunter/services/job-services.dart';
import 'package:head_hunter/utils/constants/app-assets.dart';
import 'package:head_hunter/utils/constants/colors.dart';
import 'package:head_hunter/utils/constants/fonts.dart';
import 'package:head_hunter/utils/customWidgets/my-text.dart';
import 'package:head_hunter/utils/customWidgets/round-button.dart';
import 'package:head_hunter/utils/customWidgets/symetric-padding.dart';
import 'package:head_hunter/utils/extensions/global-functions.dart';
import 'package:head_hunter/utils/extensions/sizebox.dart';
import 'package:head_hunter/utils/routes/routes-name.dart';

class JobDetailView extends StatelessWidget {
  const JobDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    String jobId = ModalRoute.of(context)?.settings.arguments as String;
    final List<String> tags = [
      "Financial Analysis",
      "Portfolio Management",
      "Investment Research",
      "Risk Management",
      "Data Analysis",
      "Excel Proficiency",
      "Communication Skills",
      "Analytical Thinking",
    ];

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
          child: SymmetricPadding(
              child: SingleChildScrollView(
        child: FutureBuilder(
            future: JobServices.fetchJobData(jobId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                    padding: EdgeInsets.only(top: 350.h),
                    child: const Center(child: CircularProgressIndicator()));
              }
              var data = snapshot.data;
              List<String> s = data!.tags;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.height,
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 39.h,
                      width: 39.w,
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffD8DADC)),
                          shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ),
                  20.height,
                  Container(
                    // height: 204.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(12.r)),
                    child: Column(
                      children: [
                        20.height,
                        FutureBuilder(
                            future: CompanyServices.fetchCompanyData(
                                data.companyId),
                            builder: (context, cSnapshot) {
                              if (cSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox();
                              }
                              var data = cSnapshot.data;
                              return Container(
                                height: 48.h,
                                width: 48.w,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(data!.imgUrl)),
                                    borderRadius: BorderRadius.circular(8.r)),
                              );
                            }),
                        10.height,
                        MyText(
                          text: capitalizeEachWord(data.openJob),
                          color: whiteColor,
                          fontWeight: FontWeight.w600,
                          size: 14.sp,
                        ),
                        3.height,
                        MyText(
                          text: capitalizeEachWord(data.companyName),
                          color: whiteColor,
                          fontWeight: FontWeight.w400,
                          size: 14.sp,
                          fontFamily: AppFonts.poppins,
                        ),
                        10.height,
                        SizedBox(
                          width: 180.w,
                          child: const Divider(
                            color: whiteColor,
                          ),
                        ),
                        10.height,
                        Container(
                          height: 24.h,
                          width: 133.w,
                          decoration: BoxDecoration(
                              color: const Color(0xffE9F0F4),
                              borderRadius: BorderRadius.circular(4.r)),
                          child: Center(
                            child: MyText(
                              text:
                                  "${data.totalSlots.toString()} Slots Remaining",
                              color: const Color(0xff5E5E5E),
                              fontWeight: FontWeight.w400,
                              size: 14.sp,
                              fontFamily: AppFonts.poppins,
                            ),
                          ),
                        ),
                        10.height,
                        MyText(
                          text:
                              "Posted on ${changeDateFormat(data.postedTime)}",
                          color: whiteColor,
                          fontWeight: FontWeight.w400,
                          size: 14.sp,
                          fontFamily: AppFonts.poppins,
                        ),
                        20.height,
                      ],
                    ),
                  ),
                  20.height,
                  MyText(
                    text: "Job Description",
                    fontWeight: FontWeight.w600,
                    size: 16.sp,
                    color: primaryColor,
                  ),
                  5.height,
                  const Divider(),
                  5.height,
                  Text(
                    data.jobDescription.toString(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppFonts.poppins,
                      color: primaryColor,
                      letterSpacing: 2,
                    ),
                  ),
                  20.height,
                  MyText(
                    text: "Required Skills",
                    fontWeight: FontWeight.w600,
                    size: 16.sp,
                    color: primaryColor,
                  ),
                  5.height,
                  const Divider(),
                  5.height,
                  // Wrap(
                  //   spacing: 8.0, // Horizontal spacing between tags
                  //   runSpacing: 8.0, // Vertical spacing between rows
                  //   children: tags.map((tag) {
                  //     return Container(
                  //       height: 32.h,
                  //       width: 160.w,
                  //       padding: EdgeInsets.symmetric(horizontal: 12.w), // Optional padding for better layout
                  //       decoration: BoxDecoration(
                  //         color: const Color(0xffF5F8FA),
                  //         borderRadius: BorderRadius.circular(20.r),
                  //         border: Border.all(color: primaryColor),
                  //       ),
                  //       child: Center(
                  //         child: Padding(
                  //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //           child: MyText(
                  //             text: tag, // Dynamically display tag text
                  //             fontWeight: FontWeight.w400,
                  //             size: 12.sp,
                  //             color: primaryColor,
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   }).toList(),
                  // )
                  Wrap(
                    spacing: 8.0, // Horizontal spacing between tags
                    runSpacing: 8.0, // Vertical spacing between rows
                    children: s.map((tag) {
                      return Chip(
                        color: const WidgetStatePropertyAll(Color(0xffF5F8FA)),
                        label: MyText(
                          text: tag, // Dynamically display tag text
                          fontWeight: FontWeight.w400,
                          size: 13.sp,
                          color: primaryColor,
                        ),
                      );
                    }).toList(),
                  ),
                  20.height,
                  RoundButton(
                      title: "Apply",
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: whiteColor,
                                child: ConfirmationDialog(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, RoutesNames.applyJobView,
                                        arguments: jobId);
                                  },
                                ),
                              );
                            });
                      })
                ],
              );
            }),
      ))),
    );
  }
}

class ConfirmationDialog extends StatelessWidget {
  final VoidCallback onPressed;
  const ConfirmationDialog({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        10.height,
        Image.asset(
          AppAssets.tickIcon,
          scale: 3,
        ),
        10.height,
        Text(
          "Are you sure to apply?",
          style: GoogleFonts.kronaOne(
              fontSize: 18.sp,
              color: primaryColor,
              fontWeight: FontWeight.w400),
        ),
        2.height,
        MyText(
          text: "Click Confirm if you wanna apply",
          fontFamily: AppFonts.poppins,
          size: 12.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xff949494),
        ),
        10.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RoundButton(
                width: 140.w,
                textColor: primaryColor,
                bgColor: transparentColor,
                borderColor: primaryColor,
                title: "Cancel",
                onTap: () {
                  Navigator.pop(context);
                }),
            RoundButton(width: 140.w, title: "Confirm", onTap: onPressed),
          ],
        ),
        10.height,
      ],
    );
  }
}
