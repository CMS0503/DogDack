import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/main_controll.dart';
import 'package:dogdack/navigators/calender_navigator.dart';
import 'package:dogdack/navigators/chart_navigator.dart';

//navigator
import 'package:dogdack/navigators/home_navigator.dart';
import 'package:dogdack/navigators/mypage_navigator.dart';

import 'package:dogdack/navigators/walk_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import '../models/user_data.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final mainController = Get.put(MainController());
  final userController = Get.put(UserController());

  final userRef = FirebaseFirestore.instance
      .collection('Users/${FirebaseAuth.instance.currentUser!.email.toString()}/UserInfo')
      .withConverter(
      fromFirestore: (snapshot, _) => UserData.fromJson(snapshot.data()!),
      toFirestore: (userData, _) => userData.toJson());

  final int _currentTabIndex = 0;

  void initUserDB() async {
    final userInfoRef = FirebaseFirestore.instance.collection('Users/${'yihe4728@gmail.com'}/UserInfo');
    QuerySnapshot _userInfoDoc = await userInfoRef.get();
    if(_userInfoDoc.docs.length == 0) {
      userInfoRef.get().then((value) {
        userInfoRef.doc('information').set(UserData(isHost: false, ).toJson());
      });
    } else {
      userInfoRef.get().then((value) {
        userController.isHost = value.docs[0]['isHost'];
        if(userController.isHost == true) {
          // 호스트 계정으로 설정
          userController.loginEmail = value.docs[0]['hostEmail'];
        } else {
          // 접속한 계정으로 설정
          userController.loginEmail = FirebaseAuth.instance.currentUser!.email.toString();
        }
      });
    }
  }

  // void _tabSelect(int tabIndex) {
  @override
  Widget build(BuildContext context) {
    if(userController.initFlag == false) {
      //여기서 유저 데이터 DB 초기화
      initUserDB();
      userController.initFlag = true;
    }

    return Obx(() => Scaffold(
          body: Stack(children: [
            Offstage(
              offstage: mainController.tabindex != 0,
              child: HomeNavigator(),
            ),
            Offstage(
              offstage: mainController.tabindex != 1,
              child: WalkNavigator(),
            ),
            Offstage(
              offstage: mainController.tabindex != 2,
              child: const CalenderNavigator(),
            ),
            Offstage(
              offstage: mainController.tabindex != 3,
              child: const ChartNavigator(),
            ),
            Offstage(
              offstage: mainController.tabindex != 4,
              child: const MyPageNavigator(),
            ),
          ]),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.pets_outlined), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
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
