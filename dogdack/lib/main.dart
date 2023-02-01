import 'package:dogdack/screens/login/login_after_screen.dart';
import 'package:flutter/material.dart';

//screen

import 'package:dogdack/screens/login/login_screen.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

//firebase
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initializeDateFormatting();

  runApp(const GetMaterialApp(
    title: 'Navigation',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return LoginAfterPage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
