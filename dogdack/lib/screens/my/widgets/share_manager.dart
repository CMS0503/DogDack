import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/screens/my/widgets/mypage_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:restart_app/restart_app.dart';

import '../../../controllers/user_controller.dart';
import '../../../models/user_data.dart';

class ShareManager extends StatefulWidget {
  const ShareManager({Key? key}) : super(key: key);

  @override
  State<ShareManager> createState() => _ShareManagerState();
}

class _ShareManagerState extends State<ShareManager> {
  late CollectionReference<UserData> userRef;
  late CollectionReference<UserData> hostRef;

  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    userRef = FirebaseFirestore.instance
        .collection('Users/${FirebaseAuth.instance.currentUser!.email}/UserInfo')
        .withConverter(
        fromFirestore: (snapshot, _) => UserData.fromJson(snapshot.data()!),
        toFirestore: (userData, _) => userData.toJson());

    hostRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/UserInfo')
        .withConverter(
        fromFirestore: (snapshot, _) => UserData.fromJson(snapshot.data()!),
        toFirestore: (userData, _) => userData.toJson());

    // 디바이스 사이즈 크기 정의
    final Size size = MediaQuery.of(context).size;

    // 반려견 정보 표시 카드의 너비, 높이 정의
    final double petInfoWidth = size.width * 0.8;
    final double petInfoHeight = size.height * 0.15;

    return Container(
      child: Center(
        child: Container(
          height: petInfoHeight,
          width: petInfoWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                blurRadius: 5.0,
                spreadRadius: 0.0,
                offset: const Offset(0, 7),
              )
            ],
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(petInfoWidth * 0.05, 0, petInfoWidth * 0.05, 0),
              child: userController.isHost ? Container(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () {
                    var map = Map<String, dynamic>();
                    map['hostEmail'] = '';
                    map['isHost'] = false;

                    userRef.doc('information').update(map)
                        .whenComplete(() => Restart.restartApp())
                        .catchError((error) => print('전화번호 저장 오류! ${error}'));
                  },
                  child: Text('공유 계정 해제'),
                ),
              ) : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StreamBuilder(
                    stream: hostRef.snapshots(),
                    builder: (hostContext, hostSnapshot) {
                      if(!hostSnapshot.hasData)
                        return CircularProgressIndicator();

                      return ElevatedButton(
                        onPressed: () {
                          showTextInputDialog(
                              context: context,
                              title: '공유 계정 로그인',
                              message: '강아지 정보를 공유 받고 싶은 계정 이메일과 비밀번호를 입력하세요!',
                              textFields: [
                                DialogTextField(
                                  keyboardType: TextInputType.emailAddress,
                                  hintText: '이메일을 입력하세요',
                                ),
                                DialogTextField(
                                  keyboardType: TextInputType.number,
                                  hintText: '비밀번호를 입력하세요',
                                )
                              ]
                          ).then((inputValue) {
                            // 취소를 누를 경우
                            if(inputValue == null)
                              return;

                            // 문서 중에 해당하는 이름의 문서를 찾는다.
                            FirebaseFirestore.instance.collection('Users').doc(inputValue.elementAt(0)).get().then((emailValue) {
                              if(emailValue.exists) {
                                // 해당하는 이름의 문서가 있으면 계정의 비밀번호와 비교
                                FirebaseFirestore.instance.collection('Users/${inputValue.elementAt(0)}/UserInfo').get().then((hostDoc) {
                                  String hostPass = hostDoc.docs[0].get('password');
                                  String inputPass = inputValue.elementAt(1);

                                  if(inputPass.length != 0 && hostPass.compareTo(inputPass) == 0) {
                                    //로그인 성공
                                    //내 계정에 호스트 이메일을 등록함.
                                    var map = Map<String, dynamic>();
                                    map['hostEmail'] = inputValue.elementAt(0).toString();
                                    map['isHost'] = true;

                                    userRef.doc('information').update(map)
                                        .whenComplete(() => Restart.restartApp())
                                        .catchError((error) {
                                      MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.InvalidLogin);
                                    });
                                  } else {
                                    MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.InvalidLogin);
                                  }
                                });
                              }
                              return;
                            });
                          });
                        },
                        child: Text('공유 계정 로그인'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Color(0xff646CAA)),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                        ),
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: userRef.snapshots(),
                    builder: (userContext, userSnapshot) {
                      if(!userSnapshot.hasData)
                        return CircularProgressIndicator();

                      return ElevatedButton(
                        onPressed: () {
                          String getPassword = '아직 비밀번호가 등록되지 않았어요!';
                          if(userSnapshot.data!.docs[0].get('password').toString() != 0) {
                            getPassword = userSnapshot.data!.docs[0].get('password');
                          }

                          showTextInputDialog(
                              context: context,
                              title: '공유 비밀번호 설정',
                              message: '나와 강아지 정보를 공유하고 싶은 사람에게 비밀번호를 알려주세요!\n현재 비밀번호 : ${getPassword}',
                              textFields: [
                                DialogTextField(
                                  keyboardType: TextInputType.number,
                                  hintText: '비밀번호를 입력하세요',
                                )
                              ]
                          ).then((value) {
                            // 취소를 누를 경우
                            if(value == null)
                              return;

                            var map = Map<String, dynamic>();
                            map['password'] = value.elementAt(0).toString();

                            if(value.elementAt(0).toString().length == 0) {
                              MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.PasswordNotExist);
                              return;
                            }

                            userRef.doc('information').update(map)
                                .whenComplete(() => print('변경 완료'))
                                .catchError((error) => print('전화번호 저장 오류! ${error}'));
                          });
                        },
                        child: Text('비밀 번호 설정'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Color(0xff646CAA)),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
