import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:head_hunter/models/company-model.dart';
import 'package:head_hunter/providers/loading-provider.dart';
import 'package:head_hunter/providers/sign-up-provider.dart';
import 'package:head_hunter/services/auth-services.dart';
import 'package:head_hunter/services/company-services.dart';
import 'package:head_hunter/utils/constants/app-assets.dart';
import 'package:head_hunter/utils/constants/fonts.dart';
import 'package:head_hunter/utils/extensions/sizebox.dart';
import 'package:head_hunter/utils/save-account-type.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../models/auth-model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/customWidgets/my-text.dart';
import '../../../utils/customWidgets/round-button.dart';
import '../../../utils/customWidgets/symetric-padding.dart';
import '../../../utils/customWidgets/text-field.dart';
import '../../../utils/extensions/global-functions.dart';


class CompanyAccountView extends StatefulWidget {
  const CompanyAccountView({super.key});

  @override
  State<CompanyAccountView> createState() => _CompanyAccountViewState();
}

class _CompanyAccountViewState extends State<CompanyAccountView> {


  final companyNameController=TextEditingController();
  final numberOfEmployeeController=TextEditingController();
  final locationController=TextEditingController();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  bool isObscure=true;
  String networkImg='';
  File? image;
  final _picker = ImagePicker();
  Future getImage({required source}) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      image = File(pickedFile.path);

      setState(() {});
    } else {}
  }
  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }
  void fetchData()async{
    DocumentSnapshot data=await FirebaseFirestore.instance.collection('company').doc(FirebaseAuth.instance.currentUser!.uid).get();
    companyNameController.text=data['companyName'];
    numberOfEmployeeController.text=data['numberOfEmployee'].toString();
    locationController.text=data['location'];
    networkImg=data['imgUrl'];
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);
    return Scaffold(
      backgroundColor: whiteColor,
      body: SymmetricPadding(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                50.height,

                Center(child: MyText(text: "Update Profile",size: 32.sp,fontWeight: FontWeight.w600,color: primaryColor,)),
                20.height,
                GestureDetector(
                  onTap: () => getImage(source: ImageSource.gallery),
                  child: Center(
                    child: Container(
                      height: 150.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        border: Border.all(style: BorderStyle.solid, color: blackColor),
                        shape: BoxShape.circle,
                        image: image != null
                            ? DecorationImage(
                          image: FileImage(image!),
                          fit: BoxFit.cover,
                        )

                            : DecorationImage(
                          image: NetworkImage(networkImg!),
                          fit: BoxFit.cover,
                        )
                      ),
                    ),
                  ),
                ),
                50.height,
                MyText(text: "Company Name",fontWeight: FontWeight.w400,size: 14.sp),
                5.height,
                CustomTextFiled(
                  controller: companyNameController,
                  hintText: "Company Name",
                  isShowPrefixImage: false,
                  isShowPrefixIcon: false,
                  isFilled: true,
                  isBorder: true,
                  borderRadius: 10.r,

                ),

                15.height,
                MyText(text: "Number of Employee",fontWeight: FontWeight.w400,size: 14.sp),
                5.height,
                CustomTextFiled(
                  controller: numberOfEmployeeController,
                  hintText: "Number of Employee",
                  keyboardType: TextInputType.number,
                  isShowPrefixImage: false,
                  isShowPrefixIcon: false,
                  isFilled: true,
                  isBorder: true,
                  borderRadius: 10.r,
                ),
                15.height,
                MyText(text: "Location",fontWeight: FontWeight.w400,size: 14.sp),
                5.height,
                CustomTextFiled(
                  controller: locationController,
                  hintText: "Your Location",
                  keyboardType: TextInputType.text,
                  isShowPrefixImage: false,
                  isShowPrefixIcon: false,
                  isFilled: true,
                  isBorder: true,
                  borderRadius: 10.r,
                ),

                20.height,
                RoundButton(
                    isLoad: true,
                    title: "Update", onTap: ()async{

                  if(companyNameController.text.isEmpty||
                      numberOfEmployeeController.text.isEmpty||
                      locationController.text.isEmpty){
                    showSnackbar(context, "Please enter complete detail",color: redColor);
                    return;
                  }
                  loadingProvider.setLoading(true);
                  String im=image==null?networkImg :await CompanyServices.uploadPicture(image!);
                  await CompanyServices.updateCompany(FirebaseAuth.instance.currentUser!.uid,
                      {
                        'companyName':companyNameController.text,
                        'location':locationController.text,
                        'imgUrl':im,
                        'numberOfEmployee': int.parse(numberOfEmployeeController.text.trim().toString()),
                      });
                  loadingProvider.setLoading(false);
                }),
                20.height,


              ],
            ),
          ),
        ),
      ),

    );
  }
}
