import 'package:dogdack/controlls/main_controll.dart';
import 'package:dogdack/navigators/calender_navigator.dart';

//navigator
import 'package:dogdack/navigators/home_navigator.dart';
import 'package:dogdack/navigators/mypage_navigator.dart';

import 'package:dogdack/navigators/walk_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final mainController = Get.put(MainController());

  int _currentTabIndex = 0;

  // void _tabSelect(int tabIndex) {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser;

    return Obx(() => Scaffold(
          body: Stack(children: [
            Offstage(
              offstage: mainController.tabindex != 0,
              child: HomeNavigator(),
            ),
            Offstage(
              offstage: mainController.tabindex != 1,
              child: const CalenderNavigator(),
            ),
            Offstage(
              offstage: mainController.tabindex != 2,
              child: WalkNavigator(),
            ),
            Offstage(
              offstage: mainController.tabindex != 3,
              child: const MyPageNavigator(),
            ),
          ]),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: '캘린더',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.pets_outlined),
                label: '산책',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '마이',
              ),
            ],
            selectedItemColor: const Color.fromARGB(255, 100, 92, 170),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            unselectedLabelStyle: const TextStyle(fontFamily: 'bmjua'),
            selectedLabelStyle: const TextStyle(fontFamily: 'bmjua'),
            elevation: 0,
            unselectedItemColor: Colors.grey,
            currentIndex: mainController.tabindex,
            onTap: (value) => mainController.changeTabIndex(value),
          ),
        ));
  }
}
