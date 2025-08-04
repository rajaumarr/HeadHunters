import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:head_hunter/main.dart';
import 'package:head_hunter/services/job-services.dart';
import 'package:head_hunter/utils/constants/app-assets.dart';
import 'package:head_hunter/utils/constants/colors.dart';
import 'package:head_hunter/utils/constants/fonts.dart';
import 'package:head_hunter/utils/customWidgets/round-button.dart';
import 'package:head_hunter/utils/customWidgets/symetric-padding.dart';
import 'package:head_hunter/utils/customWidgets/text-field.dart';
import 'package:head_hunter/utils/customWidgets/top-widgets.dart';
import 'package:head_hunter/utils/extensions/global-functions.dart';
import 'package:head_hunter/utils/extensions/sizebox.dart';
import 'package:head_hunter/utils/global-function.dart';
import 'package:head_hunter/utils/routes/routes-name.dart';

import '../../../services/company-services.dart';
import '../../../utils/customWidgets/my-text.dart';

class CompanyHomeView extends StatefulWidget {
  const CompanyHomeView({super.key});

  @override
  State<CompanyHomeView> createState() => _CompanyHomeViewState();
}

class _CompanyHomeViewState extends State<CompanyHomeView> {
  List<Map<String,String>> data=[
    {
      'name':'Chartered Accountant',
      'img':AppAssets.dummyCompanyOne,
    },
    {
      'name':'Chartered Accountant',
      'img':AppAssets.dummyCompanyOne,
    },
    {
      'name':'Loans Officer',
      'img':AppAssets.dummyCompanyTwo,
    },
    {
      'name':'Internal Auditor',
      'img':AppAssets.dummyCompanyThree,
    },
  ];
  final currentUser=FirebaseAuth.instance.currentUser!.uid;
  final searchController=TextEditingController();
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
              FutureBuilder(
                  future: CompanyServices.fetchCompanyData(currentUser),
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return const SizedBox();
                    }
                    var data=snapshot.data;
                    return   Row(
                      children: [
                        Container(
                          height: 52.h,
                          width: 52.w,
                          decoration: BoxDecoration(
                              border: Border.all(width: 2.sp),
                              image: DecorationImage(image: NetworkImage(data!.imgUrl)),
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
                              text: data!.companyName.toString(),
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              size: 12.sp,
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
              20.height,
              CustomTextFiled(
                controller: searchController,
                onChange: (v){
                  setState(() {

                  });
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
              MyText(
                  text: "Job Post", fontWeight: FontWeight.w400, size: 16.sp,color: primaryColor,),
              20.height,
              StreamBuilder(
                  stream: JobServices.fetchAllJobForSpecificStream(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return const CircularProgressIndicator();
                    }

                    if(snapshot.data!.isEmpty){
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(50.0),
                          child: MyText(text: "Not Posted any job yet"),
                        ),
                      );
                    }
                    var data=snapshot.data;
                    var filteredList=data!.where((d){
                      return searchController.text.toString().isEmpty || d.companyName.toString().toLowerCase().contains(
                        searchController.text.toString().toLowerCase())||d.openJob.toString().toString().contains(
                          searchController.text.toString().toLowerCase()
                      );
                    }).toList();
                    if(filteredList.isEmpty){
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(50.0),
                          child: MyText(text: "Not found"),
                        ),
                      );
                    }
                return Expanded(
                  flex: 4,
                  child: ListView.builder(
                    itemCount: filteredList!.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context,index){
                      var jobData=filteredList[index];

                      int totalApplicants=jobData.applicationsId.length;
                    return FutureBuilder(
                        future: CompanyServices.fetchCompanyData(jobData.companyId),
                        builder: (context,cSnapshot){
                          if(cSnapshot.connectionState==ConnectionState.waiting){
                            return const SizedBox();
                          }
                          var data=cSnapshot.data;
                      return Container(
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
                                      borderRadius: BorderRadius.circular(8.r)),
                                  child: Image.network(
                                    data!.imgUrl,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                                10.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 200.w,

                                      child: MyText(
                                        text:capitalizeEachWord( jobData.openJob),
                                        color: primaryColor,
                                        overflow: TextOverflow.clip,
                                        fontWeight: FontWeight.w400,
                                        size: 12.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 200.w,
                                      child: MyText(
                                        text:capitalizeEachWord( jobData.companyName),
                                        color: purpleColor,
                                        overflow: TextOverflow.clip,

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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      text: capitalizeEachWord(jobData.level),
                                      color: purpleColor,
                                      fontWeight: FontWeight.w400,
                                      size: 14.sp,
                                    ),
                                    MyText(
                                      text: capitalizeEachWord(jobData.openJob),
                                      color: primaryColor,
                                      fontWeight: FontWeight.w400,
                                      size: 12.sp,
                                    ),
                                    15.height,
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pushNamed(context, RoutesNames.jobApplicantsView,arguments: jobData.jobId);
                                          },
                                          child: Container(
                                            width: 115.w,
                                            height: 24.h,
                                            decoration: BoxDecoration(
                                                color: const Color(0xffE9F0F4),

                                                border: Border.all(
                                                    color:const Color(0xffD3DFE7),
                                                    width: 2
                                                ),
                                                borderRadius: BorderRadius.circular(4.r)
                                            ),
                                            child: Center(
                                              child:  MyText(text: "${totalApplicants.toString()} Applications",
                                                fontWeight: FontWeight.w400,
                                                size: 12.sp,
                                                fontFamily: AppFonts.poppins,
                                                color: primaryColor,
                                              ),

                                            ),
                                          ),
                                        ),
                                        10.width,
                                        Container(
                                          width: 115.w,
                                          height: 24.h,
                                          decoration: BoxDecoration(
                                              color: const Color(0xffE9F0F4),
                                              border: Border.all(
                                                  color:const Color(0xffD3DFE7),
                                                  width: 2
                                              ),
                                              borderRadius: BorderRadius.circular(4.r)
                                          ),
                                          child: Center(
                                            child:  MyText(text: "${jobData.totalSlots} Slots Remaining",
                                              fontWeight: FontWeight.w400,
                                              size: 12.sp,
                                              fontFamily: AppFonts.poppins,
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
                      );
                    });
                  }),
                );
              }),
              RoundButton(
                  bgColor: transparentColor,
                  borderColor: primaryColor,
                  textColor: primaryColor,
                  title: "Post New Job", onTap: (){
                    Navigator.pushNamed(context, RoutesNames.jobPostView);

              }),
              10.height,


            ],
          ),
        ),
      ),
    );
  }
}
