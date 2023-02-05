import 'package:dogdack/screens/login/login_after_screen.dart';
import 'package:flutter/material.dart';

//screen
import 'package:dogdack/screens/login/login_screen.dart';
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

  // dateformatting 사용을 위한 함수
  // locale에서 최소 1회 실행해야 함
  initializeDateFormatting();

  runApp(
    MaterialApp(
      title: 'dogdack',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 100, 92, 170),
        fontFamily: 'bmjua',
        //textButtonTheme:,
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 100, 92, 170),
          ),
          bodyText2: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
      home: const MyApp(),
    ),
  );
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
            return const LoginAfterPage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
