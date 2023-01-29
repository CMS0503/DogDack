import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_date_picker.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_edit_bollean.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_edit_image.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_edit_walk.dart';
import 'package:flutter/material.dart';

class CalendarScheduleEdit extends StatefulWidget {
  const CalendarScheduleEdit({super.key});

  @override
  State<CalendarScheduleEdit> createState() => _CalendarScheduleEditState();
}

class _CalendarScheduleEditState extends State<CalendarScheduleEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            DatePicker(),
            ScheduleEditWalk(),
            SizedBox(
              height: 30,
            ),
            ScheduleEditBollean(),
            ScheduleEditImage(),
          ],
        ),
      ),
    );
  }
}
