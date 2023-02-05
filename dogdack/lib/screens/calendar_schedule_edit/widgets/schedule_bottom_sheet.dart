// import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_edit_text.dart';
// import 'package:flutter/material.dart';

// class ScheduleBottomSheet extends StatefulWidget {
//   const ScheduleBottomSheet({super.key});

//   @override
//   State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
// }

// class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
//   @override
//   Widget build(BuildContext context) {
//     // viewinsets : 스크린 부분에서 시스템 적인 ui때문에 가려진 사이즈
//     final bottomInset = MediaQuery.of(context).viewInsets.bottom;
//     return GestureDetector(
//       onTap: () {
//         // 아무데나 눌러도 키보드 닫히게
//         FocusScope.of(context).requestFocus(FocusNode());
//       },
//       child: Column(
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: TextField(
//               decoration: InputDecoration(
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: Colors.black,
//                   ),
//                 ),
//                 labelText: 'hi',
//               ),
//             ),
//           ),
//           ScheduleEditText(name: '하이')
//         ],
//       ),
//     );
//   }
// }
