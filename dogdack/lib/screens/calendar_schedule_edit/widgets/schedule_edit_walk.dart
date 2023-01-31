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

    // print(place);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
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
          // walk_input(width: width),
          // const SizedBox(
          //   height: 10,
          // ),
          // walk_input(width: width),
          // const SizedBox(
          //   height: 10,
          // ),
          // walk_input(width: width),
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
