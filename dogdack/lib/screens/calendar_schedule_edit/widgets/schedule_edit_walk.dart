import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_edit_text.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_number_picker.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_time_picker.dart';
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
  final int _currentValue = 0;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    // print(place);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: height * 0.05,
            width: width,
            child: Row(
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.pets,
                      color: Color.fromARGB(255, 100, 92, 170),
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '산책',
                        style: TextStyle(
                          fontFamily: 'bmjua',
                          fontSize: 32,
                          color: Color.fromARGB(255, 100, 92, 170),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const ScheduleEditText(name: '장소'),
          const SizedBox(height: 10),
          ScheduleTimePicker(start_end: '시작'),
          const SizedBox(height: 10),
          ScheduleTimePicker(start_end: '종료'),
          const SizedBox(height: 10),
          const ScheduleNumberPicker(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// class walk_input extends StatelessWidget {
//   const walk_input({
//     Key? key,
//     required this.width,
//   }) : super(key: key);

//   final double width;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           alignment: Alignment.center,
//           width: width * 0.22,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//               width: 2,
//               color: const Color.fromARGB(255, 100, 92, 170),
//             ),
//           ),
//           child: const Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: 20,
//               vertical: 7,
//             ),
//             child: Text(
//               '장소',
//               style: TextStyle(
//                 fontFamily: 'bmjua',
//                 fontSize: 20,
//                 color: Color.fromARGB(255, 100, 92, 170),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(
//           width: width * 0.03,
//         ),
//         Container(
//           width: width * 0.65,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//             color: Colors.grey[300],
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.grey,
//                 offset: Offset(0.0, 3.0),
//                 blurRadius: 3.0,
//               )
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 20,
//               vertical: 10,
//             ),
//             child: Text(
//               '선택 장소',
//               style: TextStyle(
//                 fontFamily: 'bmjua',
//                 fontSize: 18,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
