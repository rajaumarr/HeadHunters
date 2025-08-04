import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:head_hunter/models/auth-model.dart';
import 'package:head_hunter/models/seeker-model.dart';
import 'package:head_hunter/providers/sign-up-provider.dart';
import 'package:head_hunter/services/auth-services.dart';
import 'package:head_hunter/services/job-services.dart';
import 'package:head_hunter/utils/constants/app-assets.dart';
import 'package:head_hunter/utils/constants/fonts.dart';
import 'package:head_hunter/utils/extensions/global-functions.dart';
import 'package:head_hunter/utils/extensions/sizebox.dart';
import 'package:head_hunter/utils/save-account-type.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/loading-provider.dart';
import '../../services/seeker-services.dart';
import '../../utils/constants/colors.dart';
import '../../utils/customWidgets/my-text.dart';
import '../../utils/customWidgets/round-button.dart';
import '../../utils/customWidgets/symetric-padding.dart';
import '../../utils/customWidgets/text-field.dart';
import '../../utils/routes/routes-name.dart';

class SeekerAccountView extends StatefulWidget {
  const SeekerAccountView({super.key});

  @override
  State<SeekerAccountView> createState() => _SeekerAccountViewState();
}

class _SeekerAccountViewState extends State<SeekerAccountView> {


  final userNameController=TextEditingController();
  final ageController=TextEditingController();
  final genderController=TextEditingController();
  String networkImg='';
  bool isObscure=true;
  File? image;
  final _picker = ImagePicker();
  Future getImage({required source}) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      image = File(pickedFile.path);

      setState(() {});
    } else {}
  }  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }
  void fetchData()async{
    DocumentSnapshot data=await FirebaseFirestore.instance.collection('job-seekers').doc(FirebaseAuth.instance.currentUser!.uid).get();
    userNameController.text=data['userName'];
    ageController.text=data['age'].toString();
    genderController.text=data['gender'];
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

                50.height,
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
                          image: NetworkImage(networkImg),
                          fit: BoxFit.cover,
                        ),
                      ),

                    ),
                  ),
                ),
                50.height,
                MyText(text: "Username",fontWeight: FontWeight.w400,size: 14.sp),
                5.height,
                CustomTextFiled(
                  controller: userNameController,
                  hintText: "Your username",
                  isShowPrefixImage: false,
                  isShowPrefixIcon: false,
                  isFilled: true,
                  isBorder: true,
                  borderRadius: 10.r,

                ),

                15.height,
                MyText(text: "Age",fontWeight: FontWeight.w400,size: 14.sp),
                5.height,
                CustomTextFiled(
                  controller: ageController,
                  hintText: "Your Age",
                  isShowPrefixImage: false,
                  isShowPrefixIcon: false,
                  isFilled: true,
                  isBorder: true,
                  borderRadius: 10.r,
                  keyboardType: TextInputType.number,

                ),
                15.height,
                MyText(text: "Gender",fontWeight: FontWeight.w400,size: 14.sp),
                5.height,
                CustomTextFiled(
                  controller: genderController,
                  hintText: "Your Gender",
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
                  if(userNameController.text.isEmpty||
                      ageController.text.isEmpty||
                      genderController.text.isEmpty){
                    showSnackbar(context, "Please enter complete detail",color: redColor);
                    return;
                  }
                  if(genderController.text.trim()!='Male'&&
                      genderController.text.trim()!='male'&&
                      genderController.text.trim()!='Female'&&genderController.text.trim()!='female'&&
                      genderController.text.trim()!='Other'&&genderController.text.trim()!='other'){
                    showSnackbar(context, "Please enter correct gender",color: redColor);
                    return;
                  }
                  loadingProvider.setLoading(true);
                  String im=image==null?networkImg :await UserServices.uploadProfile(image!);
                  await UserServices.updateUser(FirebaseAuth.instance.currentUser!.uid,
                      {
                        'userName':userNameController.text,
                        'imgUrl':im,
                        'gender':genderController.text,
                        'age': int.parse(ageController.text.trim().toString()),
                      });
                  loadingProvider.setLoading(false);

                }),

                20.height
              ],
            ),
          ),
        ),
      ),

    );
  }
}
