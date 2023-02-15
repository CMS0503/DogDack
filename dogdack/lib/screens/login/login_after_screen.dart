import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/user_controller.dart';
import '../../models/user_data.dart';

class LoginAfterPage extends StatefulWidget {
  LoginAfterPage({super.key});

  final userController = Get.put(UserController());

  void initUserDB() {
    final userColRef = FirebaseFirestore.instance.collection('Users');
    final userInfoRef = FirebaseFirestore.instance.collection('Users/${FirebaseAuth.instance.currentUser!.email}/UserInfo');

    userController.loginEmail = FirebaseAuth.instance.currentUser!.email.toString();

    FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.email).get().then((value){
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
  _LoginAfterPage createState() {
    initUserDB();
    return _LoginAfterPage();
  }
}

class _LoginAfterPage extends State<LoginAfterPage> {
  final inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 이미지 + dogdack 글자 넣을 로우
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/login/login_image.png',
                  width: width * 0.25,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'DOG DACK',
                    style: TextStyle(
                      fontFamily: 'bmjua',
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 100, 92, 170),
                    ),
                  ),
                )
              ],
            ),

            Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 8),
                child: Text(
                  // 로그인을 하면 닉네임이 나와야 한다.
                  '${FirebaseAuth.instance.currentUser!.displayName}님의 댕댕이 산책 발자취',
                  style: const TextStyle(
                      fontFamily: 'bmjua',
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(137, 80, 78, 91),
                      fontSize: 20),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    '도그닥',
                    style: TextStyle(
                        fontFamily: 'bmjua',
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 100, 92, 170),
                        fontSize: 25),
                  ),
                  Text(
                    '에 오신걸 환영합니다.',
                    style: TextStyle(
                        fontFamily: 'bmjua',
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 80, 78, 91),
                        fontSize: 25),
                  ),
                ],
              )
            ]),
          ],
        ),
      ),
    );
  }

}
