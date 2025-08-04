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
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/constants/fonts.dart';
import '../../utils/customWidgets/top-widgets.dart';

class JobApplicantsView extends StatelessWidget {
  const JobApplicantsView({super.key});

  @override
  Widget build(BuildContext context) {
    final String jobId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: SafeArea(
        child: SymmetricPadding(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('jobs').doc(jobId).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final jobData = snapshot.data!.data() as Map<String, dynamic>;
              final List<dynamic> applicantsIds = jobData['appliedApplicantsDetail'] ?? [];

              applicantsIds.sort((a, b) {
                double scoreA = double.tryParse(a['similarityScore']?.toString() ?? '0') ?? 0;
                double scoreB = double.tryParse(b['similarityScore']?.toString() ?? '0') ?? 0;
                return scoreB.compareTo(scoreA);
              });

              return Column(
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
                          child: const Center(child: MyText(text: "Not found any Applicants")))
                      : Expanded(
                          child: ListView.builder(
                              itemCount: applicantsIds.length,
                              itemBuilder: (context, index) {
                                var applicantId = applicantsIds[index];
                                String? decision; // Variable to store the selected value

                                // Remove the FutureBuilder for user data and use applicantId fields directly
                                return Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(color: const Color(0xffD3DFE7)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          AppAssets.furcIcon,
                                          scale: 3,
                                        ),
                                        10.width,
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: capitalizeEachWord(applicantId['userName'] ?? 'Unknown'),
                                              color: primaryColor,
                                              size: 14.sp,
                                            ),
                                            5.height,
                                            MyText(
                                              text: applicantId['email'] ?? '',
                                              color: const Color(0xff858BBD),
                                              size: 12.sp,
                                            ),
                                            5.height,
                                            Container(
                                              height: 24.h,
                                              decoration: BoxDecoration(
                                                  color: const Color(0xffE9F0F4),
                                                  border: Border.all(color: const Color(0xffD3DFE7), width: 2),
                                                  borderRadius: BorderRadius.circular(4.r)),
                                              child: Center(
                                                child: MyText(
                                                  text: applicantId['similarityScore'] != null
                                                      ? "${double.tryParse(applicantId['similarityScore'].toString())?.toStringAsFixed(2) ?? '0.00'} % Job Match"
                                                      : "Score not available",
                                                  fontWeight: FontWeight.w400,
                                                  size: 12.sp,
                                                  fontFamily: AppFonts.poppins,
                                                  color: primaryColor,
                                                ),
                                              ),
                                            ),
                                            10.width,
                                          ],
                                        ),
                                        const Spacer(),
                                        DropdownButton<String>(
                                          value: applicantId['status'] == 'Accepted'
                                              ? 'Accept'
                                              : applicantId['status'] == 'Rejected'
                                                  ? 'Reject'
                                                  : 'Decision',
                                          hint: const Text("Decision"),
                                          items: ["Decision", "Accept", "Reject"]
                                              .map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) async {
                                            if (newValue != null && newValue != 'Decision') {
                                              await JobServices.updateApplicantStatus(
                                                jobId: jobId,
                                                applicantUserId: applicantId['userId'],
                                                newStatus: newValue == "Accept" ? "Accepted" : "Rejected",
                                                context: context,
                                              );
                                            }
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 18.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                String fileName = Uri.parse(applicantsIds[index]['cvUrl']).pathSegments.last;
                                                JobServices.downloadAndSaveFile(applicantsIds[index]['cvUrl'], fileName);
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
                              }),
                        )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}