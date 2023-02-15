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
    Color grey = Color.fromARGB(255, 80, 78, 91);
    return   Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0,
        child: Container(
          width: width * 0.9,
          height: height * 0.25,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  child: Image.network(widget.diary_image, loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress){
                    if(loadingProgress == null){
                      return child;
                    }
                    return Center(
                      child: Image.asset('images/login/login_image.png')
                    );
                  },
                  ),),
                // child: Container(
                //   width: 130,
                //   height: 130,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //   ),
                //   child: Image.network(widget.diary_image, height: 130, width: 130,loadingBuilder: ,)
                // ),
              ),
              Text("${widget.diary_text}", style: TextStyle(
                fontFamily: 'bmjua',
                color: grey,
                fontSize: 18
              ),)

            ],
          ),
        ),
      ),
    );
  }
}
