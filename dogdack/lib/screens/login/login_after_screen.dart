import 'dart:async';

import 'package:dogdack/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginAfterPage extends StatefulWidget {
  const LoginAfterPage({super.key});
  @override
  _LoginAfterPage createState() => _LoginAfterPage();
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

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MainPage()));
    });
  }
}
