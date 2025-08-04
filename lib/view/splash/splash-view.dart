import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:head_hunter/utils/extensions/sizebox.dart';
import 'package:head_hunter/view/splash/splash-services.dart';

import '../../utils/constants/app-assets.dart';
import '../../utils/constants/colors.dart';
import '../../utils/customWidgets/my-text.dart';


class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    // TODO: implement initState
    SplashServices().isLoggedIn(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
            gradientColorOne,
            gradientColorTwo
          ],
          begin: Alignment.topCenter,end: Alignment.bottomRight
          )
        ),
        child: Column(
          children: [
            const Spacer(),
            Image.asset(AppAssets.appIcon,scale: 3,),
            const Spacer(),
            SpinKitCircle(
              color: whiteColor,
              size: 50.sp,
            ),
            10.height,
          ],
        ),
      )
    );
  }
}
