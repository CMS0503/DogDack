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
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/dogs.png'),
                ),
                const Text(
                  'DOG DACK',
                  style: TextStyle(
                    fontFamily: 'bmjua',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                child: const Text("Google 계정으로 로그인"),
                onPressed: () {
                  googleAuthSignIn();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
