
import 'package:flutter/material.dart';
import 'package:head_hunter/bottomNav/companyBottomNav.dart';
import 'package:head_hunter/bottomNav/employeeBottomNav.dart';
import 'package:head_hunter/utils/routes/routes-name.dart';
import 'package:head_hunter/view/auth/choose-view.dart';
import 'package:head_hunter/view/auth/sign-in-view.dart';
import 'package:head_hunter/view/companyView/job-applications-view.dart';
import 'package:head_hunter/view/companyView/job/post-job-view.dart';
import 'package:head_hunter/view/job/apply-job-view.dart';
import 'package:head_hunter/view/job/job-detail-view.dart';


import '../../view/auth/sign-up.dart';
import '../../view/bottom/home-view.dart';
import '../../view/companyView/auth/company-sign-up-view.dart';
import '../../view/splash/splash-view.dart';
import '../../view/welcome/welcome-view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RoutesNames.splashView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashView());
      case RoutesNames.welcomeView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const WelcomeView());
      case RoutesNames.signUpView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignUpView());
        case RoutesNames.signInView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignInView());
      case RoutesNames.homeView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeView());
        case RoutesNames.chooseView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ChooseView());
        case RoutesNames.bottomNav:
        return MaterialPageRoute(
            builder: (BuildContext context) => const BottomNavView());
        case RoutesNames.companyBottomNav:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CompanyBottomNavView());
        case RoutesNames.jobDetailView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const JobDetailView(),settings: routeSettings);
        case RoutesNames.jobPostView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const PostJobView());
        case RoutesNames.applyJobView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ApplyJobView(),settings: routeSettings);
        case RoutesNames.companySignUpView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CompanySignUpView());
      case RoutesNames.jobApplicantsView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const JobApplicantsView(),settings: routeSettings);

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No routes defined'),
            ),
          );
        });
    }
  }
}
