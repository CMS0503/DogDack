import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/input_controller.dart';
import 'package:dogdack/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DiaryWidget extends StatefulWidget {
  String diaryImage;
  String? diaryText;
  DiaryWidget({super.key, required this.diaryImage, required this.diaryText});

  @override
  State<DiaryWidget> createState() => _DiaryWidget();
}

class _DiaryWidget extends State<DiaryWidget> {
  final userController = Get.put(UserController());
  final inputController = Get.put(InputController());

  Future<void> getDiary() async {
    String docId =
        inputController.dognames[inputController.selectedValue.toString()];

    CollectionReference calRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets/$docId/Calendar');

    var diaryDoc = await calRef
        .doc(DateFormat('yyMMdd').format(inputController.date))
        .get();
    widget.diaryText = diaryDoc['diary'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDiary().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    Color grey = const Color.fromARGB(255, 80, 78, 91);
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0,
        child: SizedBox(
          width: width * 0.9,
          height: height * 0.25,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                    width: 130,
                    height: 130,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: grey),
                    child: Image.asset(widget.diaryImage)),
              ),
              Text(
                "${widget.diaryText}",
                // 'fjsdklfsajdfksad;fjsdkal;fjadsk;lfsajd;',
                style:
                    TextStyle(fontFamily: 'bmjua', color: grey, fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }
}
