import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/input_controller.dart';
import 'package:dogdack/controllers/user_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DiaryWidget extends StatefulWidget {
  String diaryImage = '';
  String? diaryText;
  DiaryWidget({super.key, required this.diaryImage, required this.diaryText});

  @override
  State<DiaryWidget> createState() => _DiaryWidget();
}

class _DiaryWidget extends State<DiaryWidget> {
  FirebaseStorage storage = FirebaseStorage.instance;
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
    print('그렇다면 여기는?');
    print(inputController.date);
    if (diaryDoc['imageUrl'].length != 0) {
      print('여기는 지나가나?');
      widget.diaryImage = diaryDoc['imageUrl'][0];
    }
  }

  // getImages() async {
  //   String docId =
  //       inputController.dognames[inputController.selectedValue.toString()];
  //   CollectionReference calRef = FirebaseFirestore.instance
  //       .collection('Users/${userController.loginEmail}/Pets/$docId/Calendar');
  //   var diaryDoc = await calRef
  //       .doc(DateFormat('yyMMdd').format(inputController.date))
  //       .get();
  //   if (inputController.imageUrl.isNotEmpty) {
  //     widget.diaryImage = inputController.imageUrl[0].toString();
  //   }
  //   setState(() {});
  // }

  // Future<void> test() async {
  //   var dogDoc = await FirebaseFirestore.instance
  //       .collection('Users/1109ssh.code@gmail.com/Pets')
  //       .doc('eVXhh9h8Xo85JSfdz2Tp')
  //       .collection('Calendar')
  //       .doc('230216')
  //       .get();
  //   print(dogDoc['imageUrl']);
  // }

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
    // getImages();
    // test();
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    Color grey = const Color.fromARGB(255, 80, 78, 91);

    return SizedBox(
      width: width * 0.9,
      height: height * 0.5,
      child: Container(
        alignment: Alignment.center,
        width: width * 0.9,
        height: height * 0.35,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "${widget.diaryText}",
              // 'fjsdklfsajdfksad;fjsdkal;fjadsk;lfsajd;',
              style: TextStyle(fontFamily: 'bmjua', color: grey, fontSize: 18),
            ),
            // Image(imageUrl: inputController.imageUrl[0])
            // Image(image: image.network())
            // CachedNetworkImage(imageUrl: inputController.imageUrl[0]),
            SizedBox(
              width: 200,
              height: 200,
              child: widget.diaryImage != ''
                  ? Image.network(
                      widget.diaryImage,
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
