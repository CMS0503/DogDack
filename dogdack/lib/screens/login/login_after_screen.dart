import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user_data.dart';

class LoginAfterPage extends StatefulWidget {
  LoginAfterPage({super.key});
  @override
  _LoginAfterPage createState() => _LoginAfterPage();
}

class _LoginAfterPage extends State<LoginAfterPage>{

  final inputController = TextEditingController();
  void fbstoreWrite() {
    FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.email.toString())
        .withConverter(
      fromFirestore: (snapshot, options) =>
          UserData.fromJson(snapshot.data()!),
      toFirestore: (value, options) => value.toJson(),
    )
        .add(UserData(
        userText: inputController.text, createdAt: Timestamp.now()))
        .then((value) => print("document added"))
        .catchError((error) => print("Fail to add doc ${error}"));
  }

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
                Padding(
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
                padding: EdgeInsets.only(top: 15, bottom: 8),
                child: Text(
                  // 로그인을 하면 닉네임이 나와야 한다.
                  '${FirebaseAuth.instance.currentUser!.displayName}님의 댕댕이 산책 발자취',
                  style: TextStyle(
                      fontFamily: 'bmjua',
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(137, 80, 78, 91),
                      fontSize: 20),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
    Timer(Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    });
  }
}

class FirestoreRead extends StatefulWidget {
  const FirestoreRead({super.key});

  @override
  State<FirestoreRead> createState() => _FirestoreReadState();
}

class _FirestoreReadState extends State<FirestoreRead> {
  final userTextColRef = FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser!.email.toString())
      .withConverter(
      fromFirestore: (snapshot, _) => UserData.fromJson(snapshot.data()!),
      toFirestore: (movie, _) => movie.toJson());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userTextColRef.orderBy('createdAt').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("There is no data!");
        }
        if (snapshot.hasError) {
          return Text("Failed to read the snapshot");
        }

        return Expanded(
          child: ListView(
            //리스트뷰 써보자! 왜냐면 데이터가 많을 거니까!
            shrinkWrap: true, //이거 없으면 hasSize에서 에러발생!!
            //snapshot을 map으로 돌려버림!
            children: snapshot.data!.docs.map((document) {
              return Column(children: [
                Divider(
                  thickness: 2,
                ),
                ListTile(title: Text(document.data().userText!))
              ]); //Listtile 생성!
            }).toList(), //map을 list로 만들어서 반환!
          ),
        );
      },
    );
  }
}



