import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_edit_text.dart';
import 'package:flutter/material.dart';

class ScheduleEditWalk extends StatefulWidget {
  const ScheduleEditWalk({super.key});

  @override
  State<ScheduleEditWalk> createState() => _ScheduleEditWalkState();
}

class _ScheduleEditWalkState extends State<ScheduleEditWalk> {
  String place = '';
  int time = 0;
  int distance = 0;

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
          const SizedBox(height: 10),
          Row(
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
                  '산책',
                  style: TextStyle(
                    fontFamily: 'bmjua',
                    fontSize: 32,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const ScheduleEditText(name: '장소'),
          const SizedBox(height: 10),
          const ScheduleEditText(name: '시간'),
          const SizedBox(height: 10),
          const ScheduleEditText(name: '거리'),
        ],
      ),
    );
  }
}
