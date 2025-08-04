import 'package:flutter/material.dart';
import 'package:head_hunter/utils/constants/colors.dart';
import 'package:head_hunter/view/bottom/application-view.dart';
import 'package:head_hunter/view/bottom/home-view.dart';
import 'package:head_hunter/view/bottom/profile-view.dart';

class BottomNavView extends StatefulWidget {
  const BottomNavView({super.key});

  @override
  State<BottomNavView> createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  final screens = [
    const HomeView(),
    const ApplicationView(),
    const ProfileView()
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (n) {
            setState(() {
              currentIndex = n;
            });
          },
          selectedItemColor: primaryColor,
          selectedLabelStyle: const TextStyle(color: primaryColor),
          items: const [
            BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                label: 'Application', icon: Icon(Icons.work)),
            BottomNavigationBarItem(
                label: 'Profile', icon: Icon(Icons.person_pin)),
          ]),
    );
  }
}
