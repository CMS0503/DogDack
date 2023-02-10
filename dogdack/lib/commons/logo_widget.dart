import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget with PreferredSizeWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return AppBar(
      toolbarHeight: height * 0.12,
      elevation: 0,
      // foregroundColor: const Color.fromARGB(255, 80, 78, 91),
      backgroundColor: Colors.white,
      centerTitle: false,
      title: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: height * 0.05, right: width * 0.5),
            child: const Text(
              'DOG DACK',
              style: TextStyle(
                fontFamily: 'bmjua',
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 80, 78, 91),
                fontSize: 28,
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: width * 0.9,
              child: const Divider(
                color: Color.fromARGB(255, 80, 78, 91),
                thickness: 1,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
