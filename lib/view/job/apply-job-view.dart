import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:head_hunter/providers/loading-provider.dart';
import 'package:head_hunter/services/similarityScoreService/similarityScore.dart';
import 'package:head_hunter/utils/constants/app-assets.dart';
import 'package:head_hunter/utils/constants/colors.dart';
import 'package:head_hunter/utils/constants/fonts.dart';
import 'package:head_hunter/utils/customWidgets/my-text.dart';
import 'package:head_hunter/utils/customWidgets/round-button.dart';
import 'package:head_hunter/utils/customWidgets/symetric-padding.dart';
import 'package:head_hunter/utils/customWidgets/top-widgets.dart';
import 'package:head_hunter/utils/extensions/global-functions.dart';
import 'package:head_hunter/utils/extensions/sizebox.dart';
import 'package:head_hunter/utils/routes/routes-name.dart';
import 'package:provider/provider.dart';

import '../../services/company-services.dart';
import '../../services/job-services.dart';
import '../../utils/customWidgets/text-field.dart';

class ApplyJobView extends StatefulWidget {
  const ApplyJobView({super.key});

  @override
  State<ApplyJobView> createState() => _ApplyJobViewState();
}

class _ApplyJobViewState extends State<ApplyJobView> {
  String? path;
  String? jobDescription = '';
  String? name;
  String? size;
  @override
  Widget build(BuildContext context) {
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
    String jobId = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
          child: SymmetricPadding(
              child: FutureBuilder(
                  future: JobServices.fetchJobData(jobId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                          padding: EdgeInsets.only(top: 350.h),
                          child:
                              const Center(child: CircularProgressIndicator()));
                    }
                    var data = snapshot.data;
                    jobDescription = data!.jobDescription;


                    List<String> s = data.tags;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.height,
                        TopWidget(
                          title: "Apply",
                          onPressed: () {
                            Navigator.pop(context);
                          },
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
                                              image:
                                                  NetworkImage(data!.imgUrl)),
                                          borderRadius:
                                              BorderRadius.circular(8.r)),
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
                          text: "Upload File",
                          size: 14.sp,
                          fontFamily: AppFonts.poppins,
                        ),
                        10.height,
                        GestureDetector(
                          onTap: () async {
                            if (path == null && name == null && size == null) {
                              await pickFile();
                            }
                          },
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: Radius.circular(5.r),
                            padding: EdgeInsets.all(14.sp),
                            color: greyColor,
                            child: ClipRRect(
                              child: SizedBox(
                                width: double.maxFinite,
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 20.r,
                                      backgroundColor: lightGreyColor,
                                      child: Image.asset((path == null &&
                                              name == null &&
                                              size == null)
                                          ? AppAssets.documentUpload
                                          : AppAssets.success),
                                    ),
                                    10.height,
                                    if (path == null &&
                                        name == null &&
                                        size == null) ...{
                                      MyText(
                                        text: 'Click to Upload',
                                        color: primaryColor,
                                        size: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      5.height,
                                      MyText(
                                        text: '(Max. File size: 25 MB)',
                                        size: 11.sp,
                                        fontWeight: FontWeight.w400,
                                      )
                                    } else ...{
                                      MyText(
                                        text: 'File Successfully upload.',
                                        color: primaryColor,
                                        size: 13.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    }
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (path != null && name != null && size != null) ...{
                          10.height,
                          Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 8.w),
                            decoration: BoxDecoration(
                              border: Border.all(color: greyColor),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(AppAssets.document),
                                    4.width,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 270.w,
                                          child: MyText(
                                            text: name!,
                                            size: 13.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        MyText(
                                          text: '${size!}MB',
                                          size: 11.sp,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        name = null;
                                        path = null;
                                        size = null;
                                      });
                                    },
                                    child: const Icon(Icons.delete_outline))
                              ],
                            ),
                          ),
                        },
                        20.height,
                        MyText(
                          text: "Information",
                          size: 14.sp,
                          fontFamily: AppFonts.poppins,
                        ),
                        10.height,
                        CustomTextFiled(
                          hintText:
                              "Explain why you are the right person for this job ?",
                          maxLine: 4,
                          isShowPrefixImage: false,
                          isShowPrefixIcon: false,
                          isFilled: true,
                          isBorder: true,
                          borderRadius: 10.r,
                        ),
                        20.height,
                        const Spacer(),
                        RoundButton(
                            isLoad: true,
                            title: "Apply",
                            onTap: () async {
                              if (path == null) {
                                showSnackbar(context, "Please upload CV");
                                return;
                              }
                              Provider.of<LoadingProvider>(context,
                                      listen: false)
                                  .setLoading(true);

                              String? cvUrl =
                                  await JobServices.uploadCV(path!, name!);
                              customPrint("Url ================$cvUrl");

                              // now here call api and fetch and get match score4
                              var similarity = await SimilarityScoreService()
                                  .getMatchScore(
                                      resumeFile: File(path!),
                                      jobDescription: jobDescription!);
                              log(similarity.toString());
                              Map<String, dynamic> seekerData;
                              if (similarity != null) {
                                // now add job to job list
                                seekerData = {
                                  'userId':
                                      FirebaseAuth.instance.currentUser!.uid,
                                  'cvUrl': cvUrl,
                                  'description': 'applied',
                                  'similarityScore': similarity,
                                };
                              } else {
                                seekerData = {
                                  'userId':
                                      FirebaseAuth.instance.currentUser!.uid,
                                  'cvUrl': cvUrl,
                                  'description': 'applied',
                                };
                              }
                              await JobServices.addToJobList(
                                  jobId,
                                  FirebaseAuth.instance.currentUser!.uid,
                                  seekerData,
                                  context);
                            }),
                        20.height,
                      ],
                    );
                  }))),
    );
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf','docx','txt'],
      type: FileType.custom,
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.single;

      String? filePath = file.path;
      String fileName = file.name;
      int? fileSize = file.size;

      if (filePath != null) {
        setState(() {
          path = filePath;
          name = fileName;
          size = ((fileSize / 1024) / 1024).toStringAsFixed(2);
        });
        customPrint('Selected file: $filePath');
        customPrint('File name: $fileName');
        customPrint('File size: ${(fileSize / 1024) / 1024} bytes');
      }
    } else {
      customPrint('No file');
    }
  }
}

class AppliedSuccessDialog extends StatelessWidget {
  const AppliedSuccessDialog({super.key});

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
          "Applied Successfully!",
          style: GoogleFonts.kronaOne(
              fontSize: 18.sp,
              color: primaryColor,
              fontWeight: FontWeight.w400),
        ),
        2.height,
        MyText(
          text: "You have successfully applied for the job. ",
          fontFamily: AppFonts.poppins,
          size: 12.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xff949494),
        ),
        10.height,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: RoundButton(
              title: "Go to Home",
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesNames.bottomNav,
                  (route) => false,
                );
              }),
        ),
        10.height,
      ],
    );
  }
}
