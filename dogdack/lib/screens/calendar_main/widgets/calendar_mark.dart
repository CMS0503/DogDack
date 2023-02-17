import 'package:flutter/material.dart';

class CalendarMark extends StatelessWidget {
  const CalendarMark({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: width * 0.1,
              child: const Icon(
                Icons.pets,
                color: Color.fromARGB(255, 100, 92, 170),
              ),
            ),
            SizedBox(
              width: width * 0.8,
              child: const Text(
                '산책한 날',
                style: TextStyle(
                  fontFamily: 'bmjua',
                  fontSize: 20,
                  color: Color.fromARGB(255, 100, 92, 170),
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: width * 0.1,
              child: const Icon(
                Icons.cut_outlined,
                color: Color.fromARGB(255, 191, 172, 224),
              ),
            ),
            SizedBox(
              width: width * 0.8,
              child: const Text(
                '미용한 날',
                style: TextStyle(
                    fontFamily: 'bmjua',
                    fontSize: 20,
                    color: Color.fromARGB(255, 191, 172, 224)),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: width * 0.1,
              child: const Icon(
                Icons.bathtub_outlined,
                color: Color.fromARGB(255, 221, 137, 189),
              ),
            ),
            SizedBox(
              width: width * 0.8,
              child: const Text(
                '목욕한 날',
                style: TextStyle(
                  fontFamily: 'bmjua',
                  fontSize: 20,
                  color: Color.fromARGB(255, 221, 137, 189),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
