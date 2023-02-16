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

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  final userController = Get.put(UserController());

  void initUserDB() async {
    final userColRef = FirebaseFirestore.instance.collection('Users');
    final userInfoRef = FirebaseFirestore.instance.collection('Users/${FirebaseAuth.instance.currentUser!.email}/UserInfo');

    userController.loginEmail = FirebaseAuth.instance.currentUser!.email.toString();

    await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.email).get().then((value){
      if(value.exists) {
        userInfoRef.get().then((value) {
          userController.isHost = value.docs[0]['isHost'];
          if(userController.isHost == true) {
            // 호스트 계정으로 설정
            userController.loginEmail = value.docs[0]['hostEmail'];
          } else {
            // 접속한 계정으로 설정
            userController.loginEmail = FirebaseAuth.instance.currentUser!.email.toString();
          }

          userController.update();
        });
      } else {
        userColRef.get().then((value) {
          userColRef.doc(FirebaseAuth.instance.currentUser!.email).set({});
        });
        userInfoRef.get().then((value) {
          userInfoRef.doc('information').set(UserData(isHost: false, hostEmail: '', password: '', phoneNumber: '').toJson());
        });
      }
    });
  }

  @override
  State<MainPage> createState(){
    if(userController.initFlag == false) {
      initUserDB();
      userController.initFlag = true;
    }
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  final mainController = Get.put(MainController());
  final userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Obx(() => Scaffold(
      body: Stack(children: [
        Offstage(
          offstage: mainController.tabindex != 0,
          child: GetBuilder<UserController>(builder: (_) {
            return HomeNavigator();
          },),
        ),
        Offstage(
          offstage: mainController.tabindex != 1,
          child: GetBuilder<UserController>(builder: (_) {
            return WalkNavigator();
          },),
        ),
        Offstage(
          offstage: mainController.tabindex != 2,
          child: GetBuilder<UserController>(builder: (_) {
            return CalenderNavigator();
          },),
        ),
        Offstage(
          offstage: mainController.tabindex != 3,
          child: GetBuilder<UserController>(builder: (_) {
            return ChartNavigator();
          },),
        ),
        Offstage(
          offstage: mainController.tabindex != 4,
          child: GetBuilder<UserController>(builder: (_) {
            return MyPageNavigator();
          },),
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