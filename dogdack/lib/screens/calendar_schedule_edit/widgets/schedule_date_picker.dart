import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/input_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/user_controller.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  // 오늘 날짜를 기본으로 저장
  final controller = Get.put(InputController());

  DateTime date = DateTime.now();

  // 강아지 이름 불러오기 추가
  // final dogRef = FirebaseFirestore.instance
  //     .collection('Users/${userController.loginEmail}/Calendar')
  //     .withConverter(
  //         fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!),
  //         toFirestore: (dogData, _) => dogData.toJson());

  // dogname =

  // var selectedValue = '';
  // final Map<String, List<Object>> events = {'': []};
  final userController = Get.put(UserController());

  var petsRef = FirebaseFirestore.instance
      .collection('Users/${FirebaseAuth.instance.currentUser!.email}/Pets');

  String docId = '';

  getName() async {
    var dogDoc = await petsRef.get();
    List<String> dogs = [];
    // 자.. 여기다가 등록된 강아지들 다 입력하는거야
    for (int i = 0; i < dogDoc.docs.length; i++) {
      dogs.insert(0, dogDoc.docs[i]['name']);
    }
    controller.valueList = dogs;

    // 근데 강아지들이 없으면?
    if (dogs.isEmpty) {
      '그냥 넘어가야지 뭐';
    } else {
      // 강아지들이 있는데 처음 들어왔을 때 강아지 선택을 안한 상태면
      if (controller.selectedValue == '') {
        // 그냥 처음 강아지로 가져오기
        controller.selectedValue = dogs[0];

        setState(() {});
        // }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    petsRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets');
    getName();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // 년월일
                        children: [
                          TextButton(
                            child: Row(
                              children: [
                                Text(
                                  '${controller.date.year}년 ${controller.date.month}월 ${controller.date.day}일 ${DateFormat.E('ko_KR').format(controller.date)}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'bmjua',
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                // 달력 아이콘
                                const Icon(
                                  Icons.calendar_month,
                                  color: Color.fromARGB(255, 100, 92, 170),
                                  size: 32,
                                ),
                              ],
                            ),
                            // Row 클릭하면 Datepicker 팝업 뜨게
                            onPressed: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );
                              // print(newDate);
                              setState(() {
                                controller.date = newDate!;
                              });

                              // if (newDate == null) return;
                            },
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10, left: 20),
                              child: controller.selectedValue.isEmpty
                                  ? GestureDetector(
                                      child: const Text('멍멍이를 선택해주세요'),
                                      onTap: () {
                                        setState(() {});
                                      },
                                    )
                                  : DropdownButton(
                                      icon: const Icon(
                                        Icons.expand_more,
                                        color: Colors.black,
                                        size: 28,
                                      ),
                                      underline: Container(),
                                      value: controller.selectedValue,
                                      items: controller.valueList.map(
                                        (value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'bmjua',
                                                fontSize: 22,
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          controller.selectedValue =
                                              value.toString();
                                          // getName();
                                          controller.saveName =
                                              controller.selectedValue;
                                        });
                                      },
                                    ),
                            ),
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
    );
  }
}
