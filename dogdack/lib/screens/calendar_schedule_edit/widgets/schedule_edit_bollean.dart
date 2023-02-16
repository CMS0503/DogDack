import 'package:dogdack/controllers/input_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          const BolleanBtn(name: '목욕'),
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
          const BolleanBtn(name: '미용'),
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

// class bool_input extends StatelessWidget {
//   const bool_input({
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
//           width: width * 0.43,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//               width: 2,
//               color: Colors.grey,
//             ),
//           ),
//           child: const Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: 20,
//               vertical: 7,
//             ),
//             child: Text(
//               '진행',
//               style: TextStyle(
//                 fontFamily: 'bmjua',
//                 fontSize: 20,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ),
//         SizedBox(
//           width: width * 0.02,
//         ),
//         Container(
//           alignment: Alignment.center,
//           width: width * 0.43,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//               width: 2,
//               color: Colors.grey,
//             ),
//           ),
//           child: const Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: 20,
//               vertical: 7,
//             ),
//             child: Text(
//               '미진행',
//               style: TextStyle(
//                 fontFamily: 'bmjua',
//                 fontSize: 20,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class BolleanBtn extends StatefulWidget {
  final name;
  const BolleanBtn({
    super.key,
    required this.name,
  });

  @override
  State<BolleanBtn> createState() => _BolleanBtnState();
}

class _BolleanBtnState extends State<BolleanBtn> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;

    final controller = Get.put(InputController());
    bool buttonsState = true;

    if (widget.name == '목욕') {
      buttonsState = controller.bath.value;
    } else {
      buttonsState = controller.beauty.value;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: width * 0.42,
              child: OutlinedButton(
                onPressed: () {
                  buttonsState = true;
                  setState(() {
                    if (widget.name == '목욕') {
                      controller.bath.value = buttonsState;
                    } else {
                      controller.beauty.value = buttonsState;
                    }
                  });
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: buttonsState
                        ? const Color.fromARGB(255, 100, 92, 170)
                        : const Color.fromARGB(255, 229, 229, 230),
                    width: 3,
                  ),
                ),
                child: const Text(
                  '진행',
                  style: TextStyle(
                    fontFamily: 'bmjua',
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: width * 0.42,
              child: OutlinedButton(
                onPressed: () {
                  buttonsState = false;
                  setState(() {
                    if (widget.name == '목욕') {
                      controller.bath.value = buttonsState;
                    } else {
                      controller.beauty.value = buttonsState;
                    }
                  });
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: !buttonsState
                        ? const Color.fromARGB(255, 100, 92, 170)
                        : const Color.fromARGB(255, 229, 229, 230),
                    width: 3,
                  ),
                ),
                child: const Text(
                  '미진행',
                  style: TextStyle(
                    fontFamily: 'bmjua',
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
