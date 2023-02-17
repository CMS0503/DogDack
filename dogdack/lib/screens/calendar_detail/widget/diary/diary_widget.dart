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





  @override
  Widget build(BuildContext context) {

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
          height: height * 0.28,
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
                  child:  Image.asset('images/login/login_image.png')
                  ),),


              Text("${widget.diaryText}", style: TextStyle(
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

