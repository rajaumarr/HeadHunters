import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:head_hunter/models/job_card_model.dart';
import 'package:head_hunter/services/company-services.dart';
import 'package:head_hunter/services/seeker-services.dart';
import 'package:head_hunter/utils/constants/colors.dart';
import 'package:head_hunter/utils/customWidgets/home-screen-widgets.dart';
import 'package:head_hunter/utils/customWidgets/my-text.dart';
import 'package:head_hunter/utils/customWidgets/text-field.dart';
import 'package:head_hunter/utils/extensions/sizebox.dart';
import 'package:head_hunter/utils/routes/app-routes.dart';
import 'package:head_hunter/utils/routes/routes-name.dart';

import '../../services/job-services.dart';
import '../../utils/constants/app-assets.dart';
import '../../utils/constants/fonts.dart';
import '../../utils/extensions/global-functions.dart';
import '../../utils/global-function.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<String> im = [
      'assets/images/lightning.png',
      'assets/images/pencil.png',
      'assets/images/star.png',
      'assets/images/lightning.png',
      'assets/images/pencil.png',
    ];
    List<JobCardModel> dummy = [
      JobCardModel(
          imagePath: 'assets/images/lightning.png',
          jobTitle: 'Chartered Accountant',
          companyName: 'Ecobank Ghana PLC',
          level: 'Seniors Level',
          type: 'Graphic Designer',
          tags: ['100 % Match', '5 Slots Remaining']),
      JobCardModel(
          imagePath: 'assets/images/lightning.png',
          jobTitle: 'Chartered Accountant',
          companyName: 'Ecobank Ghana PLC',
          level: 'Seniors Level',
          type: 'Graphic Designer',
          tags: ['100 % Match', '5 Slots Remaining'])
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  FutureBuilder(
                      future: UserServices.fetchUserData(currentUser),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }
                        var data = snapshot.data;
                        return Row(
                          children: [
                            Container(
                              height: 52.h,
                              width: 52.w,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(data!.imgUrl)),
                                  border: Border.all(width: 2.sp),
                                  borderRadius: BorderRadius.circular(52.r)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.w, horizontal: 2.w),
                              ),
                            ),
                            10.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                  text: getGreetingMessage(DateTime.now()),
                                  color: midGreyColor,
                                  fontWeight: FontWeight.w400,
                                  size: 14.sp,
                                ),
                                MyText(
                                  text: capitalizeEachWord(
                                      data!.userName.toString()),
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                  size: 12.sp,
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                ],
              ),
              20.height,
              CustomTextFiled(
                controller: searchController,
                onChange: (v) {
                  setState(() {});
                },
                hintText: "Search for a job or company",
                isShowPrefixImage: false,
                isShowPrefixIcon: true,
                isFilled: true,
                isBorder: true,
                borderRadius: 10.r,
                fillColor: fillColor,
                prefixIcon: Icons.search,
              ),
              20.height,
              // MyText(
              //     text: "Category", fontWeight: FontWeight.w400, size: 16.sp),
              // 20.height,
              // SizedBox(
              //   height: 70.h,
              //   child: GridView.builder(
              //     scrollDirection: Axis.horizontal,
              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //         crossAxisCount: 1,
              //         mainAxisSpacing: 16.w,
              //         childAspectRatio: 1),
              //     itemCount: 5,
              //     itemBuilder: (context, index) {
              //       return category(im[index]);
              //     },
              //   ),
              // ),
              20.height,
              MyText(
                  text: "Jobs Available",
                  fontWeight: FontWeight.w400,
                  size: 16.sp),
              20.height,

              // SizedBox(
              //   height: 200.h,
              //   child: GridView.builder(
              //     scrollDirection: Axis.horizontal,
              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //         crossAxisCount: 1,
              //         mainAxisSpacing: 16.w,
              //         childAspectRatio: 0.6),
              //     itemCount: dummy.length,
              //     itemBuilder: (context, index) {
              //       final job = dummy[index];
              //       return GestureDetector(
              //         onTap: () {
              //           Navigator.pushNamed(
              //               context, RoutesNames.jobDetailView);
              //         },
              //         child: jobCard(
              //           job.imagePath,
              //           job.jobTitle,
              //           job.companyName,
              //           job.level,
              //           job.type,
              //           job.tags,
              //         ),
              //       );
              //     },
              //   ),
              // ),
              FutureBuilder(
                future: JobServices.fetchAllJobOnce(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data == null ||
                      snapshot.data!.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(50.0),
                        child: MyText(text: "No jobs available"),
                      ),
                    );
                  }

                  var jobs = snapshot.data!;
                  var filteredList = jobs.where((d) {
                    return searchController.text.toString().isEmpty ||
                        d.companyName.toString().toLowerCase().contains(
                            searchController.text.toString().toLowerCase()) ||
                        d.openJob.toString().toLowerCase().contains(
                            searchController.text.toString().toLowerCase());
                  }).toList();

                  if (filteredList.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(50.0),
                        child: MyText(text: "No matching jobs found"),
                      ),
                    );
                  }

                  return FutureBuilder(
                    future: Future.wait(filteredList.map((job) =>
                        CompanyServices.fetchCompanyData(job.companyId))),
                    builder: (context, companiesSnapshot) {
                      if (companiesSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      var companies = companiesSnapshot.data!;
                      return Expanded(
                        flex: 5,
                        child: ListView.builder(
                          itemCount: filteredList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            var jobData = filteredList[index];
                            var companyData = companies[index];
                            int totalApplicants = jobData.applicationsId.length;

                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RoutesNames.jobDetailView,
                                    arguments: jobData.jobId);
                              },
                              child: Container(
                                width: double.maxFinite,
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                    border: Border.all(color: borderColor),
                                    color: const Color(0xffFBFCFE),
                                    borderRadius: BorderRadius.circular(12.r)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 48.w,
                                          height: 48.h,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.r)),
                                          child: Image.network(
                                            companyData?.imgUrl ?? '',
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                        10.width,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 200.w,
                                              child: MyText(
                                                overflow: TextOverflow.clip,
                                                text: capitalizeEachWord(
                                                    jobData.openJob),
                                                color: primaryColor,
                                                fontWeight: FontWeight.w400,
                                                size: 12.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 200.w,
                                              child: MyText(
                                                overflow: TextOverflow.clip,
                                                text: capitalizeEachWord(
                                                    jobData.companyName),
                                                color: purpleColor,
                                                fontWeight: FontWeight.w400,
                                                size: 14.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    10.height,
                                    const Divider(
                                      color: borderColor,
                                    ),
                                    5.height,
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 48.h,
                                          width: 48.w,
                                        ),
                                        10.width,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: capitalizeEachWord(
                                                  jobData.level),
                                              color: purpleColor,
                                              fontWeight: FontWeight.w400,
                                              size: 14.sp,
                                            ),
                                            MyText(
                                              text: capitalizeEachWord(
                                                  jobData.openJob),
                                              color: primaryColor,
                                              fontWeight: FontWeight.w400,
                                              size: 12.sp,
                                            ),
                                            15.height,
                                            Row(
                                              children: [
                                                Container(
                                                  width: 115.w,
                                                  height: 24.h,
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xffE9F0F4),
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xffD3DFE7),
                                                          width: 2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.r)),
                                                  child: Center(
                                                    child: MyText(
                                                      text:
                                                          "${jobData.totalSlots} Slots Remaining",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      size: 12.sp,
                                                      fontFamily:
                                                          AppFonts.poppins,
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    5.height,
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              // 20.height,
              // MyText(
              //     text: "Recent Jobs",
              //     fontWeight: FontWeight.w400,
              //     size: 16.sp),
              // 20.height,
              // for (var job in dummy) ...{
              //   jobCard(job.imagePath, job.jobTitle, job.companyName,
              //       job.level, job.type, job.tags),
              //   10.height,
              // }
            ],
          ),
        ),
      ),
    );
  }
}
