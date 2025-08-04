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
    final String? jobId = ModalRoute.of(context)?.settings.arguments as String?;

    if (jobId == null) {
      return Scaffold(
        body: Center(child: MyText(text: "Job ID not provided")),
      );
    }

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
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(child: MyText(text: "Failed to load job details"));
                }

                final job = snapshot.data!;
                final hasSlots = job.totalSlots > 0;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.height,
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 39.h,
                        width: 39.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffD8DADC)),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(Icons.arrow_back_rounded, size: 18.sp),
                        ),
                      ),
                    ),
                    20.height,

                    // Job Header Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        children: [
                          20.height,
                          FutureBuilder(
                            future: CompanyServices.fetchCompanyData(job.companyId),
                            builder: (context, cSnapshot) {
                              if (cSnapshot.connectionState == ConnectionState.waiting) {
                                return const SizedBox();
                              }
                              if (cSnapshot.hasError || !cSnapshot.hasData) {
                                return Container(
                                  height: 48.h,
                                  width: 48.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(Icons.business, color: Colors.grey),
                                );
                              }
                              final company = cSnapshot.data!;
                              return Container(
                                height: 48.h,
                                width: 48.w,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(company.imgUrl),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              );
                            },
                          ),
                          10.height,
                          MyText(
                            text: capitalizeEachWord(job.openJob),
                            color: whiteColor,
                            fontWeight: FontWeight.w600,
                            size: 14.sp,
                          ),
                          3.height,
                          MyText(
                            text: capitalizeEachWord(job.companyName),
                            color: whiteColor,
                            fontWeight: FontWeight.w400,
                            size: 14.sp,
                            fontFamily: AppFonts.poppins,
                          ),
                          10.height,
                          SizedBox(
                            width: 180.w,
                            child: const Divider(color: whiteColor),
                          ),
                          10.height,

                          // Slots Remaining Indicator
                          Container(
                            height: 24.h,
                            width: 133.w,
                            decoration: BoxDecoration(
                              color: hasSlots
                                  ? const Color(0xffE9F0F4)
                                  : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Center(
                              child: MyText(
                                text: hasSlots
                                    ? "${job.totalSlots} Slots Remaining"
                                    : "No Slots Available",
                                color: hasSlots
                                    ? const Color(0xff5E5E5E)
                                    : Colors.red,
                                fontWeight: FontWeight.w400,
                                size: 14.sp,
                                fontFamily: AppFonts.poppins,
                              ),
                            ),
                          ),
                          10.height,
                          MyText(
                            text: "Posted on ${changeDateFormat(job.postedTime)}",
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

                    // Job Description
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
                      job.jobDescription,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: AppFonts.poppins,
                        color: primaryColor,
                        letterSpacing: 2,
                      ),
                    ),
                    20.height,

                    // Required Skills
                    MyText(
                      text: "Required Skills",
                      fontWeight: FontWeight.w600,
                      size: 16.sp,
                      color: primaryColor,
                    ),
                    5.height,
                    const Divider(),
                    5.height,
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: job.tags.map((tag) {
                        return Chip(
                          color: const WidgetStatePropertyAll(Color(0xffF5F8FA)),
                          label: MyText(
                            text: tag,
                            fontWeight: FontWeight.w400,
                            size: 13.sp,
                            color: primaryColor,
                          ),
                        );
                      }).toList(),
                    ),
                    20.height,

                    // Apply Button
                    RoundButton(
                      title: hasSlots ? "Apply Now" : "Slots Filled",
                      bgColor: hasSlots ? primaryColor : Colors.grey,
                      onTap: () {
                        if (hasSlots) {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              backgroundColor: whiteColor,
                              child: ConfirmationDialog(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    RoutesNames.applyJobView,
                                    arguments: jobId,
                                  );
                                },
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("No slots remaining for this job"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                    20.height,
                  ],
                );
              },
            ),
          ),
        ),
      ),
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
        Image.asset(AppAssets.tickIcon, scale: 3),
        10.height,
        Text(
          "Are you sure to apply?",
          style: GoogleFonts.kronaOne(
            fontSize: 18.sp,
            color: primaryColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        2.height,
        MyText(
          text: "Click Confirm if you want to apply",
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
              onTap: () => Navigator.pop(context),
            ),
            RoundButton(
              width: 140.w,
              title: "Confirm",
              onTap: onPressed,
            ),
          ],
        ),
        10.height,
      ],
    );
  }
}