import 'package:dogdack/screens/login/login_after_screen.dart';
import 'dart:async';

//screen
import 'package:dogdack/screens/login/login_screen.dart';
import 'package:dogdack/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

//firebase
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initializeDateFormatting();

  runApp(MaterialApp(
    title: 'dogdack',
    theme: ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Color.fromARGB(255, 100, 92, 170),
      ),
      primaryColor: Color.fromARGB(255, 100, 92, 170),
      fontFamily: 'bmjua',
      //textButtonTheme:,
      textTheme: TextTheme(
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
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  bool isFinish = false;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void callDelay() async {
    // await Timer(const Duration(seconds: 3), () {});
    await Future.delayed(Duration(seconds: 3));

    widget.isFinish = true;
    setState(() {});
  }

  @override
  void initState() {
    callDelay();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return widget.isFinish == true ? MainPage() : LoginAfterPage();
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
