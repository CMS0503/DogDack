import 'package:dogdack/screens/calendar_main/widgets/calendar.dart';
import 'package:dogdack/screens/calendar_main/widgets/calendar_mark.dart';
import 'package:dogdack/screens/calendar_schedule_edit/calendar_schedule_edit.dart';
import 'package:flutter/material.dart';

class CalendarMain extends StatefulWidget {
  const CalendarMain({super.key, required this.tabIndex});
  final int tabIndex;

  @override
  State<CalendarMain> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarMain> {
  // 선택한 날짜 초기화
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  // 보여줄 월
  DateTime focusedDay = DateTime.now();

  final inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calender page")),
      floatingActionButton: renderFloatingActionButton(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Calendar(focusedDay: focusedDay),
            const CalendarMark(),
          ],
        ),
      ),
    );
  }

  renderFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: const Color.fromARGB(255, 100, 92, 170),
            width: 3,
            style: BorderStyle.solid),
      ),
      width: 48,
      height: 48,
      child: FloatingActionButton.small(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CalendarScheduleEdit(day: DateTime.now())),
          );
        },
        // focusColor: Colors.black,
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Color.fromARGB(255, 100, 92, 170),
          size: 40,
        ),
      ),
    );
  }
}
