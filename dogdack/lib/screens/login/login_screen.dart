import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//for google sign-in
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailContoller = TextEditingController();
  final passController = TextEditingController();
  String errorString = '';

  void fireAuthLogin() async {
    print('${emailContoller.text}, ${passController.text}');
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailContoller.text, password: passController.text)
        .catchError((error) => setState(() => errorString = error.message));
    // FirebaseAuth.instance.signInAnonymously();
    print("${FirebaseAuth.instance.currentUser}");
  }

  Future<UserCredential> googleAuthSignIn() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    return await FirebaseAuth.instance.signInWithCredential(credential);
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

            //구글 로그인 박스
            SizedBox(
              width: width * 0.7,
              height: height * 0.05,
              child: ElevatedButton(
                onPressed: () {
                  googleAuthSignIn();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(
                      'images/login/google_logo.png',
                      width: width * 0.06,
                    ),
                    Text(
                      '구글로 로그인하기',
                      style: TextStyle(
                          fontFamily: 'bmjua',
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 80, 78, 91),
                          fontSize: 20),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    side: const BorderSide(
                        width: 2, color: Color.fromARGB(255, 100, 92, 170))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
