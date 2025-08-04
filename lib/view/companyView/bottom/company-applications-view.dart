import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:head_hunter/main.dart';
import 'package:head_hunter/services/job-services.dart';
import 'package:head_hunter/utils/constants/app-assets.dart';
import 'package:head_hunter/utils/constants/colors.dart';
import 'package:head_hunter/utils/constants/fonts.dart';
import 'package:head_hunter/utils/customWidgets/symetric-padding.dart';
import 'package:head_hunter/utils/customWidgets/text-field.dart';
import 'package:head_hunter/utils/customWidgets/top-widgets.dart';
import 'package:head_hunter/utils/extensions/global-functions.dart';
import 'package:head_hunter/utils/extensions/sizebox.dart';

import '../../../services/company-services.dart';
import '../../../utils/customWidgets/my-text.dart';
import '../../../utils/routes/routes-name.dart';


class CompanyApplicationView extends StatefulWidget {
  const CompanyApplicationView({super.key});

  @override
  State<CompanyApplicationView> createState() => _CompanyApplicationViewState();
}

class _CompanyApplicationViewState extends State<CompanyApplicationView> {
  final searchController=TextEditingController();
  final currentUser=FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SymmetricPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.height,
              const TopWidget(title: "Applications",isShowBackButton: false,),
              20.height,
              CustomTextFiled(
                controller: searchController,
                onChange: (v){
                  setState(() {

                  });
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
              StreamBuilder(
                  stream: JobServices.fetchAllJobForSpecificStream(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return Padding(
                          padding: EdgeInsets.only(top: 350.h),
                          child: const Center(child: CircularProgressIndicator()));
                    }
                    var data= snapshot.data;
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
                        child: ListView.builder(
                            itemCount: data!.length,
                            itemBuilder: (context,index){
                              var dummyData=data[index];
                              return FutureBuilder(
                                  future: CompanyServices.fetchCompanyData(dummyData.companyId),
                                  builder: (context,cSnapshot){
                                    if(cSnapshot.connectionState==ConnectionState.waiting){
                                      return const SizedBox();
                                    }
                                    var data=cSnapshot.data;
                                return ApplicationSentWidget(
                                    onPressed: (){
                                      Navigator.pushNamed(context, RoutesNames.jobApplicantsView,arguments: dummyData.jobId);
                                    },
                                    totalApplications: dummyData.applicationsId.length.toString(),
                                    jobTitle: capitalizeEachWord(dummyData.openJob),
                                    companyTitle: capitalizeEachWord(dummyData.companyName),
                                    imgUrl: data!.imgUrl);
                              });
                            }));
                  })


            ],
          ),
        ),
      ),
    );
  }
}
class ApplicationSentWidget extends StatelessWidget {
  final String? jobTitle;
  final String companyTitle;
  final String totalApplications;
  final String imgUrl;
  final VoidCallback onPressed;
  const ApplicationSentWidget({super.key, required this.companyTitle, required this.imgUrl, this.jobTitle, required this.totalApplications, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  Container(
      //height: 104.h,
      margin: EdgeInsets.only(bottom: 10.h),
      width: double.infinity,
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1,
                  color:Color(0xffD3DFE7)
              )
          ),
          color: Color(0xffFBFCFE)
      ),
      child: Padding(
        padding: EdgeInsets.all(15.sp),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 48.h,
                  width: 48.w,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      image: DecorationImage(image: NetworkImage(imgUrl)),
                      borderRadius: BorderRadius.circular(8.r)
                  ),
                ),
                15.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 200.w,

                        child: MyText(text: jobTitle??'ss',
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.w500,size: 14.sp,fontFamily: AppFonts.poppins,)),
                    2.height,
                    SizedBox(
                      width: 200.w,

                      child: MyText(text: companyTitle,fontWeight: FontWeight.w400,
                        size: 12.sp,
                        overflow: TextOverflow.clip,

                        fontFamily: AppFonts.poppins,
                        color: const Color(0xff858BBD),
                      ),
                    ),
                    15.height,
                    GestureDetector(
                     onTap: onPressed,
                      child: Container(
                        width: 115.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:const Color(0xffD3DFE7),
                                width: 2
                            ),
                            borderRadius: BorderRadius.circular(4.r)
                        ),
                        child: Center(
                          child:  MyText(text: "${totalApplications} Applications",
                            fontWeight: FontWeight.w400,
                            size: 12.sp,
                            fontFamily: AppFonts.poppins,
                            color: primaryColor,
                          ),

                        ),
                      ),
                    )
                  ],
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
