import 'package:dogdack/screens/calendar_schedule_edit/controller/input_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleEditText extends StatefulWidget {
  final name;

  const ScheduleEditText({
    super.key,
    required this.name,
  });

  @override
  State<ScheduleEditText> createState() => _ScheduleEditTextState();
}

class _ScheduleEditTextState extends State<ScheduleEditText> {
  String place = "";

  final controller = Get.put(InputController());
  final inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return SizedBox(
      height: height * 0.05,
      width: width,
      child: Row(
        children: [
          // GetBuilder<InputController>(
          //   builder: (controller) {
          //     return Text('${controller}');
          //   },
          // ),
          // FloatingActionButton(
          //   onPressed: controller.increment,
          //   tooltip: 'Increment',
          //   child: const Icon(Icons.add),
          // ),
          Container(
            alignment: Alignment.center,
            width: width * 0.22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 2,
                color: const Color.fromARGB(255, 100, 92, 170),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 7,
              ),
              child: Text(
                '${widget.name}',
                style: const TextStyle(
                  fontFamily: 'bmjua',
                  fontSize: 20,
                  color: Color.fromARGB(255, 100, 92, 170),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: width * 0.65,
            child: TextField(
              onChanged: (value) {
                // controller.input();
                if (widget.name == '장소') {
                  controller.place = value;
                  print(controller.place);
                } else if (widget.name == '시간') {
                  controller.time = value;
                  print(controller.time);
                } else {
                  controller.distance = value;
                  print(controller.distance);
                }
                print('장소 ${controller.place}');
              },
              controller: inputController,
              // keyboardType: TextInputType.multiline,
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                labelStyle: const TextStyle(
                  // color: Colors.red,
                  fontSize: 22,
                  fontFamily: 'bmjua',
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 229, 229, 230),
                label: Text(
                  "산책 ${widget.name}",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 121, 119, 129),
                  ),
                ),
              ),
            ),
          ),

          // ElevatedButton(
          //     onPressed: () => fbstoreWrite(),
          //     child: const Text("Text Upload")),
          // const FirestoreRead(),
        ],
      ),
    );
  }
}

// class FirestoreRead extends StatefulWidget {
//   const FirestoreRead({super.key});

//   @override
//   State<FirestoreRead> createState() => _FirestoreReadState();
// }

// class _FirestoreReadState extends State<FirestoreRead> {
//   final userTextColRef = FirebaseFirestore.instance
//       .collection(FirebaseAuth.instance.currentUser!.email.toString())
//       .withConverter(
//           fromFirestore: (snapshot, _) => UserData.fromJson(snapshot.data()!),
//           toFirestore: (movie, _) => movie.toJson());

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: userTextColRef.orderBy('createdAt').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return const Text("Failed to read the snapshot");
//         }
//         if (!snapshot.hasData) {
//           return const Text("There is no data!");
//         }
//         return Column(
//           children: snapshot.data!.docs.map((document) {
//             return Column(children: [
//               const Divider(
//                 thickness: 2,
//               ),
//               ListTile(title: Text(document.data().userText!))
//             ]); //Listtile 생성!
//           }).toList(),
//         );
//         // return Expanded(
//         //   child: ListView(
//         //     //리스트뷰 써보자! 왜냐면 데이터가 많을 거니까!
//         //     shrinkWrap: true, //이거 없으면 hasSize에서 에러발생!!
//         //     //snapshot을 map으로 돌려버림!
//         //     children: snapshot.data!.docs.map((document) {
//         //       return Column(children: [
//         //         const Divider(
//         //           thickness: 2,
//         //         ),
//         //         ListTile(title: Text(document.data().userText!))
//         //       ]); //Listtile 생성!
//         //     }).toList(), //map을 list로 만들어서 반환!
//         //   ),
//         // );
//       },
//     );
//   }
// }
