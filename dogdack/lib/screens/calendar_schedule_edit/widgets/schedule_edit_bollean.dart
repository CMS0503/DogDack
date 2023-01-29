import 'package:flutter/material.dart';

class ScheduleEditBollean extends StatelessWidget {
  const ScheduleEditBollean({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      child: Column(
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 36,
                width: 5,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 100, 92, 170),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '목욕',
                  style: TextStyle(
                    fontFamily: 'bmjua',
                    fontSize: 32,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          bool_input(width: width),
          const SizedBox(
            height: 10,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 36,
                width: 5,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 100, 92, 170),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '미용',
                  style: TextStyle(
                    fontFamily: 'bmjua',
                    fontSize: 32,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          bool_input(width: width),
          const SizedBox(
            height: 10,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 36,
                width: 5,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 100, 92, 170),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '오늘의 일기',
                  style: TextStyle(
                    fontFamily: 'bmjua',
                    fontSize: 32,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class bool_input extends StatelessWidget {
  const bool_input({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          width: width * 0.43,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 2,
              color: Colors.grey,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 7,
            ),
            child: Text(
              '진행',
              style: TextStyle(
                fontFamily: 'bmjua',
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(
          width: width * 0.02,
        ),
        Container(
          alignment: Alignment.center,
          width: width * 0.43,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 2,
              color: Colors.grey,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 7,
            ),
            child: Text(
              '미진행',
              style: TextStyle(
                fontFamily: 'bmjua',
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
