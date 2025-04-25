import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:head_hunter/services/job-services.dart';
import 'package:head_hunter/services/seeker-services.dart';
import 'package:head_hunter/utils/constants/app-assets.dart';
import 'package:head_hunter/utils/constants/colors.dart';
import 'package:head_hunter/utils/customWidgets/my-text.dart';
import 'package:head_hunter/utils/customWidgets/symetric-padding.dart';
import 'package:head_hunter/utils/extensions/global-functions.dart';
import 'package:head_hunter/utils/extensions/sizebox.dart';

import '../../utils/constants/fonts.dart';
import '../../utils/customWidgets/top-widgets.dart';

class JobApplicantsView extends StatelessWidget {
  const JobApplicantsView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> applicantsIds = ModalRoute.of(context)!
        .settings
        .arguments as List<Map<String, dynamic>>;
    customPrint(applicantsIds.toString());
    return Scaffold(
      body: SafeArea(
        child: SymmetricPadding(
          child: Column(
            children: [
              20.height,
              TopWidget(
                title: "Applications",
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              20.height,
              applicantsIds.isEmpty
                  ? SizedBox(
                      height: 500.h,
                      child: const Center(
                          child: MyText(text: "Not found any Applicants")))
                  : Expanded(
                      child: ListView.builder(
                          itemCount: applicantsIds.length,
                          itemBuilder: (context, index) {
                            var applicantId = applicantsIds[index];
                            return FutureBuilder(
                                future: UserServices.fetchUserData(
                                    applicantId['userId']),
                                builder: (context, userSnapshot) {
                                  if (userSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  var applicantData = userSnapshot.data;
                                  return Container(
                                    //height: 82.h,
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                          color: const Color(0xffD3DFE7)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(
                                            AppAssets.furcIcon,
                                            scale: 3,
                                          ),
                                          10.width,
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MyText(
                                                text: capitalizeEachWord(
                                                    applicantData!.userName),
                                                color: primaryColor,
                                                size: 14.sp,
                                              ),
                                              5.height,
                                              MyText(
                                                text: applicantData.email,
                                                color: const Color(0xff858BBD),
                                                size: 12.sp,
                                              ),
                                              5.height,
                                              Container(
                                                // width: 85.w,
                                                height: 24.h,
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xffE9F0F4),
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xffD3DFE7),
                                                        width: 2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.r)),
                                                child: Center(
                                                  child: MyText(
                                                    text: applicantId[
                                                                'similarityScore'] !=
                                                            null
                                                        ? "${double.tryParse(applicantId['similarityScore'].toString())?.toStringAsFixed(2) ?? '0.00'} % Job Match"
                                                        : "Score not available",
                                                    fontWeight: FontWeight.w400,
                                                    size: 12.sp,
                                                    fontFamily:
                                                        AppFonts.poppins,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                              ),
                                              10.width,
                                            ],
                                          ),
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 18.0),
                                            child: GestureDetector(
                                                onTap: () {
                                                  JobServices
                                                      .downloadAndSaveFile(
                                                          applicantsIds[index]
                                                              ['cvUrl'],
                                                          applicantData
                                                              .userName);
                                                },
                                                child: Image.asset(
                                                  AppAssets.downloadIcon,
                                                  scale: 3,
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
