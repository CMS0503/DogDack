import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/screens/login/login_after_screen.dart';
import 'dart:async';

//screen
import 'package:dogdack/screens/login/login_screen.dart';
import 'package:dogdack/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:get/get.dart';

//firebase
import 'controllers/user_controller.dart';
import 'firebase_options.dart';
import 'models/user_data.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // dateformatting 사용을 위한 함수
  // locale에서 최소 1회 실행해야 함
  initializeDateFormatting();

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    GetMaterialApp(
      title: 'dogdack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 100, 92, 170),
        ),
        primaryColor: const Color.fromARGB(255, 100, 92, 170),
        fontFamily: 'bmjua',
        //textButtonTheme:,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color.fromARGB(255, 80, 78, 91),
          ),
          displayMedium: TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 100, 92, 170),
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 80, 78, 91),
          ),
        ),
      ),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  bool isFinish = false;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final userController = Get.put(UserController());
  late Size globalSize;

  void callDelay() async {
    // await Timer(const Duration(seconds: 3), () {});
    await Future.delayed(const Duration(seconds: 3));

    widget.isFinish = true;
    setState(() {});
  }

  DateTime? currentBackPressTime;

  onWillPop() {
    DateTime now = Timestamp.now().toDate();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: "'뒤로' 버튼을 한번 더 누르시면 종료됩니다.",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color(0xff6E6E6E),
          fontSize: globalSize.width * 0.04,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    return true;
  }

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
  void initState() {
    callDelay();
  }

  @override
  Widget build(BuildContext context) {
    globalSize = MediaQuery.of(context).size;

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          bool result = onWillPop();
          return await Future.value(result);},
        child: Scaffold(
          body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if(userController.initFlag == false) {
                  initUserDB();
                  userController.initFlag = true;
                }

                return widget.isFinish == true ? MainPage() : LoginAfterPage();
              } else {
                return const LoginPage();
              }
            },
          ),
        ),
      ),
    );
  }
}
