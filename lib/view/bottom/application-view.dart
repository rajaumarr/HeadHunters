// Restored imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:head_hunter/models/company-model.dart'; // For CompanyServices
import 'package:head_hunter/models/job-post-model.dart'; // For JobPostModel
import 'package:head_hunter/services/company-services.dart'; // For CompanyServices
import 'package:head_hunter/services/job-services.dart'; // For JobServices
import 'package:head_hunter/utils/constants/app-assets.dart'; // For placeholder image
import 'package:head_hunter/utils/constants/colors.dart';
import 'package:head_hunter/utils/constants/fonts.dart';
import 'package:head_hunter/utils/customWidgets/symetric-padding.dart';
import 'package:head_hunter/utils/customWidgets/text-field.dart';
import 'package:head_hunter/utils/customWidgets/top-widgets.dart';
import 'package:head_hunter/utils/extensions/global-functions.dart';
import 'package:head_hunter/utils/extensions/sizebox.dart';

import '../../utils/customWidgets/my-text.dart';

class ApplicationView extends StatefulWidget {
  const ApplicationView({super.key});

  @override
  State<ApplicationView> createState() => _ApplicationViewState();
}

class _ApplicationViewState extends State<ApplicationView> {
  final searchController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SymmetricPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.height,
              const TopWidget(
                title: "Applications",
                isShowBackButton: false,
              ),
              20.height,
              CustomTextFiled(
                controller: searchController,
                onChange: (v) {
                  setState(() {});
                },
                hintText: "Search for a job or company",
                isShowPrefixImage: false,
                prefixIcon: Icons.search,
                isShowPrefixIcon: true,
                isFilled: true,
                isBorder: true,
                borderRadius: 10.r,
              ),
              10.height,
              FutureBuilder<List<JobPostModel>>(
                  future: JobServices.fetchAllJobOnce(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                          padding: EdgeInsets.only(top: 200.h),
                          child:
                              const Center(child: CircularProgressIndicator()));
                    }

                    if (snapshot.hasError) {
                      return Center(
                          child: MyText(text: "Error: ${snapshot.error}"));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(50.0),
                          child: MyText(text: "No jobs available."),
                        ),
                      );
                    }

                    // Filter jobs that the user has applied to
                    var appliedJobs = snapshot.data!
                        .where(
                            (job) => job.applicationsId.contains(currentUser))
                        .toList();

                    if (appliedJobs.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(50.0),
                          child: MyText(
                              text: "You have not applied to any jobs yet."),
                        ),
                      );
                    }

                    // Apply search filter
                    var filteredList = appliedJobs.where((jobPost) {
                      final query = searchController.text.toLowerCase();
                      return query.isEmpty ||
                          jobPost.openJob.toLowerCase().contains(query) ||
                          jobPost.companyName.toLowerCase().contains(query);
                    }).toList();

                    if (filteredList.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(50.0),
                          child:
                              MyText(text: "No matching applications found."),
                        ),
                      );
                    }

                    return FutureBuilder<List<CompanyModel?>>(
                        future: Future.wait(filteredList.map((job) =>
                            CompanyServices.fetchCompanyData(job.companyId))),
                        builder: (context, companiesSnapshot) {
                          if (companiesSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          var companies = companiesSnapshot.data!;
                          return Expanded(
                              child: ListView.builder(
                                  itemCount: filteredList.length,
                                  itemBuilder: (context, index) {
                                    var jobPost = filteredList[index];
                                    var companyData = companies[index];
                                    return SeekerApplicationCard(
                                      jobPost: jobPost,
                                      currentUserUid: currentUser,
                                      companyData: companyData,
                                    );
                                  }));
                        });
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class SeekerApplicationCard extends StatelessWidget {
  final JobPostModel jobPost;
  final String currentUserUid;
  final CompanyModel? companyData;

  const SeekerApplicationCard({
    super.key,
    required this.jobPost,
    required this.currentUserUid,
    required this.companyData,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? applicantDetail = jobPost.appliedApplicantsDetail
        .firstWhere((detail) => detail['userId'] == currentUserUid,
            orElse: () => {});

    String status =
        applicantDetail.isNotEmpty && applicantDetail.containsKey('status')
            ? applicantDetail['status']
            : 'Applied';

    Color statusColor = primaryColor;
    String statusText = status;

    switch (status.toLowerCase()) {
      case 'accepted':
        statusColor = Colors.green;
        statusText = "Accepted";
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = "Rejected";
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusText = "Pending";
        break;
      default:
        statusColor = Colors.blue;
        statusText = status;
        break;
    }

    Widget imageWidget;
    if (companyData?.imgUrl != null && companyData!.imgUrl!.isNotEmpty) {
      imageWidget = Container(
        height: 48.h,
        width: 48.w,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(companyData!.imgUrl!), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(8.r)),
      );
    } else {
      imageWidget = Container(
        height: 48.h,
        width: 48.w,
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8.r)),
        child: Icon(Icons.business, color: Colors.grey.shade400, size: 24.r),
      );
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      width: double.infinity,
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffD3DFE7))),
          color: Color(0xffFBFCFE)),
      child: Padding(
        padding: EdgeInsets.all(15.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageWidget,
            15.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: capitalizeEachWord(jobPost.openJob),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w500,
                    size: 14.sp,
                    fontFamily: AppFonts.poppins,
                  ),
                  2.height,
                  MyText(
                    text: capitalizeEachWord(jobPost.companyName),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w400,
                    size: 12.sp,
                    fontFamily: AppFonts.poppins,
                    color: const Color(0xff858BBD),
                  ),
                  15.height,
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                        border: Border.all(color: statusColor, width: 1.5),
                        borderRadius: BorderRadius.circular(4.r),
                        color: statusColor.withOpacity(0.1)),
                    child: MyText(
                      text: statusText,
                      fontWeight: FontWeight.w400,
                      size: 12.sp,
                      fontFamily: AppFonts.poppins,
                      color: statusColor,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
