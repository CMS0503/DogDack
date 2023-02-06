import 'package:dogdack/screens/home/bar_char.dart';
import 'package:flutter/material.dart';
import 'package:dogdack/commons/logo_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key, required this.tabIndex});
  final int tabIndex;
  final inputController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * 0.12),
          child: const LogoWidget(),
        ),
        body: Container(child:
        BarChartSample1()
          ,));
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "안녕하세요! ${FirebaseAuth.instance.currentUser!.email} 님!",
      style: Theme.of(context).textTheme.bodyText1,
    );
  }
}

@override
Widget build(BuildContext context) {
  return const SizedBox();
}
