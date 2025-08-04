import 'package:flutter/material.dart';
import 'package:head_hunter/utils/constants/colors.dart';
import 'package:head_hunter/view/bottom/application-view.dart';
import 'package:head_hunter/view/bottom/home-view.dart';
import 'package:head_hunter/view/bottom/profile-view.dart';
import 'package:head_hunter/view/companyView/bottom/company-applications-view.dart';
import 'package:head_hunter/view/companyView/bottom/company-home-view.dart';
import 'package:head_hunter/view/companyView/bottom/company-profile-view.dart';

class CompanyBottomNavView extends StatefulWidget {
  const CompanyBottomNavView({super.key});

  @override
  State<CompanyBottomNavView> createState() => _CompanyBottomNavViewState();
}

class _CompanyBottomNavViewState extends State<CompanyBottomNavView> {

  final screens=[
   CompanyHomeView(),
    CompanyApplicationView(),
    CompanyProfileView()
  ];
  int currentIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (n){
            setState(() {
              currentIndex=n;
            });
          },
          selectedItemColor: primaryColor,
          selectedLabelStyle: const TextStyle(
              color: primaryColor
          ),
          items: const[
            BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                label: 'Application',
                icon: Icon(Icons.work)),
            BottomNavigationBarItem(
                label: 'Profile',
                icon: Icon(Icons.person_pin)),
          ]),

    );
  }
}
