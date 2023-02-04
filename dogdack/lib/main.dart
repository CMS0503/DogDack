import 'package:dogdack/screens/login/login_after_screen.dart';
//screen
import 'package:dogdack/screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//firebase
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
      ),
    );
  }
}
