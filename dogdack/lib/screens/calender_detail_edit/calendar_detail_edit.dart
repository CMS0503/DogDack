import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/button_controller.dart';
import 'package:dogdack/controllers/user_controller.dart';
import 'package:dogdack/models/calender_data.dart';
import 'package:dogdack/models/walk_data.dart';
import 'package:dogdack/controllers/input_controller.dart';
import 'package:dogdack/screens/calendar_main/calendar_main.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/calendar_snackbar.dart';
import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_edit_bollean.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

class CalendarDetailEdit extends StatefulWidget {
  // 모슨요일인지 받기
  const CalendarDetailEdit({super.key, required this.day});
  final DateTime day;

  @override
  State<CalendarDetailEdit> createState() => _CalendarDetailEditState();
}

class _CalendarDetailEditState extends State<CalendarDetailEdit> {
  final inputController = TextEditingController();
  final controller = Get.put(InputController());
  final buttonController = Get.put(ButtonController());
  final startController = TextEditingController();
  final endController = TextEditingController();
  final distanceController = TextEditingController();
  final placeController = TextEditingController();
  final userController = Get.put(UserController());

  FirebaseStorage storage = FirebaseStorage.instance;

  void selectCameraOrGallery(BuildContext context, Size size) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: size.height * 0.15,
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.075,
                  child: ListTile(
                    leading: const Icon(Icons.camera_alt_outlined),
                    title: const Text('촬영하기'),
                    onTap: () {
                      _upload('camera');
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.075,
                  child: ListTile(
                    leading: const Icon(Icons.photo_camera_back),
                    title: const Text('앨범보기'),
                    onTap: () {
                      _upload('gallery');
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _upload(String inputSource) async {
    final picker = ImagePicker();
    XFile? pickedImage;
    try {
      pickedImage = await picker.pickImage(
        source:
            inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1920,
        imageQuality: 50,
      );

      if (pickedImage == null) {
        return;
      }

      final String fileName = path.basename(pickedImage.path);
      // print('pickedImage.path : ${pickedImage.path}');
      File imageFile = File(pickedImage.path);

      try {
        // Uploading the selected image with some custom meta data
        final result = await storage
            .ref()
            .child(
                '${userController.loginEmail}/dogs/${controller.selectedValue}/${DateFormat('yyMMdd').format(controller.date)}/$fileName')
            .putFile(
              imageFile,
              SettableMetadata(
                customMetadata: {
                  'uploaded_by': 'A bad guy',
                  'description': 'Some description...'
                },
              ),
            );
        result.ref.getDownloadURL().then((value) {
          controller.imageUrl.add(value.toString());
        });

        // Refresh the UI
        setState(() {});
      } on FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  // Retriew the uploaded images
  // This function is called when the app launches for the first time or when an image is uploaded or deleted
  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage
        .ref()
        .child(
            '${userController.loginEmail}/dogs/${controller.selectedValue}/${DateFormat('yyMMdd').format(controller.date)}')
        .list();
    final List<Reference> allFiles = result.items;
    final snapshot = await FirebaseFirestore.instance
        .collection(
          'Users',
        )
        .doc(userController.loginEmail)
        .collection('Calendar')
        .doc(DateFormat('yyMMdd').format(controller.date))
        .get();

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      controller.imageUrl = [fileUrl.toString()];

      final FullMetadata fileMeta = await file.getMetadata();
      if (controller.imageUrl.contains(fileUrl)) {
        files.add({
          "url": fileUrl,
          "path": file.fullPath,
        });
      }
    });

    return files;
  }

  // Delete the selected image
  // This function is called when a trash icon is pressed
  Future<void> _delete(String ref, String url) async {
    await storage.ref(ref).delete();
    print('여기가 어딘고');
    print(controller.imageUrl);
    controller.imageUrl.remove(url);
    // Rebuild the UI
    setState(() {});
  }

  // 완료 버튼 클릭 시 데이터 저장
  void fbstoreWrite() async {
    // 현재 선택한 강아지 이름으로 강아지 저장
    controller.saveName = controller.selectedValue;
    // Pet Collection 접근
    final petsRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets');
    // 산책했는지 확인하는 변수(분)
    final walkCheck = (int.parse(controller.endTime.seconds.toString()) -
            int.parse(controller.startTime.seconds.toString())) /
        60;

    // walkCheck이 0이면 산책을 안한 것임
    if (walkCheck == 0) {
      controller.walkCheck.value = false;
    }

    // 선택된 강아지 이름으로 해당 강아지 문서 가져오기
    var result =
        await petsRef.where("name", isEqualTo: controller.saveName).get();

    // 문서의 data중 권장 산책량 data 가져오기
    var recommend = result.docs[0]['recommend'];

    // 이 if 문은 빼도 되나?
    if (result.docs.isNotEmpty) {
      // 선택한 강아지 문서 id 가져오기
      String dogId = result.docs[0].id;

      // Calendar data 입력하기
      petsRef
          .doc(dogId)
          .collection('Calendar')
          .doc(DateFormat('yyMMdd').format(controller.date).toString())
          .get()
          .then((value) {
        if (value['isWalk'] == true || walkCheck > 0) {
          controller.walkCheck.value = true;
        } else {
          controller.walkCheck.value = false;
        }
      }).then((value) {
        petsRef
            .doc(dogId)
            .collection('Calendar')
            .doc(DateFormat('yyMMdd').format(controller.date).toString())
            .withConverter(
              fromFirestore: (snapshot, options) =>
                  CalenderData.fromJson(snapshot.data()!),
              toFirestore: (value, options) => value.toJson(),
            )
            .update({
              'diary': controller.diary.value,
              'bath': controller.bath.value,
              'beauty': controller.beauty.value,
              'isWalk': controller.walkCheck.value,
              'imageUrl': controller.imageUrl,
            })
            .then((value) => print("document added"))
            .catchError((error) => print("Fail to add doc $error"));
      });

      // Walk data 입력하기
      petsRef
          .doc(dogId)
          .collection('Walk')
          .doc()
          .withConverter(
            fromFirestore: (snapshot, options) =>
                WalkData.fromJson(snapshot.data()!),
            toFirestore: (value, options) => value.toJson(),
          )
          .set(
            WalkData(
              place: controller.place,
              startTime: controller.startTime,
              endTime: controller.endTime,
              totalTimeMin: (int.parse(controller.endTime.seconds.toString()) -
                      int.parse(controller.startTime.seconds.toString())) /
                  60,
              distance: int.parse(controller.distance),
              goal: recommend,
              isAuto: false,
              geolist: [],
            ),
          );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startController.text = DateFormat('hh:mm a')
        .format(
          DateTime.fromMicrosecondsSinceEpoch(
              controller.startTime.microsecondsSinceEpoch),
        )
        .toString();
    endController.text = DateFormat('hh:mm a')
        .format(
          DateTime.fromMicrosecondsSinceEpoch(
              controller.endTime.microsecondsSinceEpoch),
        )
        .toString();
    placeController.text = controller.place;
    distanceController.text = controller.distance;
    inputController.text = controller.diary.value;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return GestureDetector(
      onTap: () {
        // 암기, 아무데나 눌러도 키보드 닫히게
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: const Text(
            '스케줄 수정',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              // 년월일, 강아지 이름 들어가는 칸
                              Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color.fromARGB(50, 100, 92, 170),
                                      width: 3,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  // 년월일
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${controller.date.year}년 ${controller.date.month}월 ${controller.date.day}일 ${DateFormat.E('ko_KR').format(controller.date)}',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontFamily: 'bmjua',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 20),
                                          child:
                                              Text(controller.selectedValue)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
              // 산책 장소, 시간, 거리
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    // 산책 장소
                    SizedBox(
                      height: height * 0.05,
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 7,
                              ),
                              child: Text(
                                '장소',
                                style: TextStyle(
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
                              // maxLength: 20,
                              onChanged: (value) {
                                controller.place = value;
                              },
                              controller: placeController,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
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
                                  fontSize: 22,
                                  fontFamily: 'bmjua',
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 229, 229, 230),
                                label: const Text(
                                  "산책 장소",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 121, 119, 129),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 시작 시간
                    SizedBox(
                      height: height * 0.05,
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 7,
                              ),
                              child: Text(
                                '시작',
                                style: TextStyle(
                                  fontFamily: 'bmjua',
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 100, 92, 170),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: width * 0.65,
                            child: TextFormField(
                              // maxLength: 20,
                              onTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                var time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (!mounted) return;
                                if (time == null) {
                                  return;
                                }
                                startController.text = time.format(context);
                                // controller.time = time.format(context);
                                // TextEditingController(text: time.format(context));
                                var dateTime = DateTime(
                                  controller.date.year,
                                  controller.date.month,
                                  controller.date.day,
                                  time.hour,
                                  time.minute,
                                );
                                controller.startTime =
                                    Timestamp.fromDate(dateTime);
                              },
                              controller: startController,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
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
                                  fontSize: 22,
                                  fontFamily: 'bmjua',
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 229, 229, 230),
                                label: const Text(
                                  "시작 시간",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 121, 119, 129),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 종료 시간
                    SizedBox(
                      height: height * 0.05,
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 7,
                              ),
                              child: Text(
                                '종료',
                                style: TextStyle(
                                  fontFamily: 'bmjua',
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 100, 92, 170),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: width * 0.65,
                            child: TextFormField(
                              // maxLength: 20,
                              onTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                var time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (!mounted) return;
                                if (time == null) {
                                  return;
                                }
                                endController.text = time.format(context);
                                // controller.time = time.format(context);
                                // TextEditingController(text: time.format(context));
                                var dateTime = DateTime(
                                  controller.date.year,
                                  controller.date.month,
                                  controller.date.day,
                                  time.hour,
                                  time.minute,
                                );
                                controller.endTime =
                                    Timestamp.fromDate(dateTime);
                              },
                              controller: endController,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
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
                                  fontSize: 22,
                                  fontFamily: 'bmjua',
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 229, 229, 230),
                                label: const Text(
                                  "종료 시간",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 121, 119, 129),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 거리
                    SizedBox(
                      height: height * 0.05,
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 7,
                              ),
                              child: Text(
                                '거리',
                                style: TextStyle(
                                  fontFamily: 'bmjua',
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 100, 92, 170),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: width * 0.65,
                            child: TextFormField(
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                var distance = Picker(
                                    cancelText: '취소하기',
                                    cancelTextStyle: const TextStyle(
                                      fontFamily: 'bmjua',
                                      color: Color.fromARGB(255, 100, 92, 170),
                                    ),
                                    confirmText: '선택하기',
                                    confirmTextStyle: const TextStyle(
                                      fontFamily: 'bmjua',
                                      color: Color.fromARGB(255, 100, 92, 170),
                                    ),
                                    adapter: NumberPickerAdapter(data: [
                                      const NumberPickerColumn(
                                        begin: 0,
                                        end: 10000,
                                        jump: 100,
                                      ),
                                    ]),
                                    hideHeader: true,
                                    title: const Text(
                                      "산책 거리를 선택해 주세요",
                                      style: TextStyle(
                                        fontFamily: 'bmjua',
                                        color:
                                            Color.fromARGB(255, 100, 92, 170),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    onConfirm: (Picker picker, List value) {
                                      distanceController.text =
                                          '${picker.getSelectedValues()[0].toString()}m';
                                      controller.distance = picker
                                          .getSelectedValues()[0]
                                          .toString();
                                      // distanceController.text = picker.getSelectedValues();
                                    }).showDialog(context);
                              },
                              // maxLength: 20,
                              onChanged: (value) {
                                // controller.time = value;
                                setState(() {});
                              },
                              controller: distanceController,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
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
                                  fontSize: 22,
                                  fontFamily: 'bmjua',
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 229, 229, 230),
                                label: const Text(
                                  "산책 거리",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 121, 119, 129),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              const SizedBox(
                height: 30,
              ),
              // 목욕 / 미용 여부
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.cut_outlined,
                              color: Color.fromARGB(255, 191, 172, 224),
                              size: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '미용',
                                style: TextStyle(
                                  fontFamily: 'bmjua',
                                  fontSize: 32,
                                  color: Color.fromARGB(255, 191, 172, 224),
                                ),
                              ),
                            ),
                          ],
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
                      children: const [
                        Icon(
                          Icons.bathtub_outlined,
                          color: Color.fromARGB(255, 221, 137, 189),
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '목욕',
                            style: TextStyle(
                              fontFamily: 'bmjua',
                              fontSize: 32,
                              color: Color.fromARGB(255, 221, 137, 189),
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
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: height * 0.37,
                      width: width * 0.85,
                      child: FutureBuilder(
                        future: _loadImages(),
                        builder: (context,
                            AsyncSnapshot<List<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.data!.isNotEmpty) {
                              return Column(
                                children: [
                                  Expanded(
                                    child: ListView.separated(
                                      separatorBuilder: ((context, index) =>
                                          const SizedBox(
                                            width: 20,
                                          )),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data?.length ?? 0,
                                      itemBuilder: (context, index) {
                                        final Map<String, dynamic> image =
                                            snapshot.data![index];
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              width: width * 0.8,
                                              height: height * 0.3,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  20,
                                                ),
                                                child: Image.network(
                                                  image['url'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: 10,
                                            //   child: IconButton(
                                            //     icon: const Icon(
                                            //       Icons.cancel,
                                            //       color: Color.fromARGB(
                                            //           255, 255, 105, 95),
                                            //     ),
                                            //     onPressed: () => _delete(
                                            //       image['path'],
                                            //       image['url'],
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  selectCameraOrGallery(context, screenSize);
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 229, 229, 230),
                                    border: Border(),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                  ),
                                  height: height * 0.3,
                                  width: width * 0.8,
                                  child: const Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 80,
                                      color:
                                          Color.fromARGB(255, 147, 147, 147)),
                                ),
                              );
                            }
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              //일기장
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    // height: height * 0.2,
                    width: width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                        maxLength: 20,
                        onChanged: (value) {
                          controller.diary.value = value;
                        },
                        controller: inputController,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                            borderSide: const BorderSide(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          labelStyle: const TextStyle(
                            // color: Colors.red,
                            fontSize: 22,
                            fontFamily: 'bmjua',
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          label: const Text(
                            "오늘의 일기를 추가해 보세요! (최대20자)",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 121, 119, 129),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: width * 0.8,
                child: ElevatedButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();

                    // 입력값 잘못되면 막기
                    // 선택한 강아지가 없으면 입력 못하게
                    if (controller.selectedValue == '') {
                      CalendarSnackBar().notfoundCalendarData(
                          context, CalendarSnackBarErrorType.NoDog);
                      return;
                    }
                    // 시작시간이 종료시간 보다 크면 입력 못하게
                    if (int.parse(controller.startTime.seconds.toString()) >
                        int.parse(controller.endTime.seconds.toString())) {
                      CalendarSnackBar().notfoundCalendarData(
                          context, CalendarSnackBarErrorType.TimeError);
                      return;
                    }
                    // 시작이나 종료 시간 중 하나만 입력할 때
                    if (controller.startTime.seconds != '0' &&
                        controller.endTime.seconds == '0') {
                      CalendarSnackBar().notfoundCalendarData(
                          context, CalendarSnackBarErrorType.TimeError);
                    }
                    if (controller.startTime.seconds == '0' &&
                        controller.endTime.seconds != '0') {
                      CalendarSnackBar().notfoundCalendarData(
                          context, CalendarSnackBarErrorType.TimeError);
                    }

                    // 문제 없으면 db에 입력하기
                    fbstoreWrite();

                    // 입력 완료하면 달력화면으로 돌아가기 위해 pop
                    Navigator.pop(context);
                    // 화면 reset하기
                    setState(() {});
                    // calendar push
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CalendarMain()));
                  },
                  // 완료 버튼 스타일
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: const Color.fromARGB(255, 100, 92, 170),
                  ),
                  // 완료 버튼 텍스트
                  child: const Text(
                    "완료",
                    style: TextStyle(
                      fontFamily: 'bmjua',
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
