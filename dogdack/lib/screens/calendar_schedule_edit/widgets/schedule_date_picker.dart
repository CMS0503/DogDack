import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/screens/calendar_schedule_edit/controller/input_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  //     .collection('Users/${FirebaseAuth.instance.currentUser!.email}/Calendar')
  //     .withConverter(
  //         fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!),
  //         toFirestore: (dogData, _) => dogData.toJson());

  // dogname =

  var selectedValue = '';
  // final Map<String, List<Object>> events = {'': []};

  final petsRef = FirebaseFirestore.instance
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
      if (selectedValue == '') {
        // 그냥 처음 강아지로 가져오기
        selectedValue = dogs[0];
        // var result =
        //     await petsRef.where("name", isEqualTo: selectedValue).get();
        // if (result.docs.isNotEmpty) {
        //   String dogId = result.docs[0].id;
        //   final calRef = petsRef.doc(dogId).collection('Calendar');
        //   var data = await calRef.get();
        //   for (int i = 0; i < data.docs.length; i++) {
        //     Calendar.events['${data.docs[i].reference.id}/$selectedValue'] = [
        //       data.docs[i]['diary'],
        //       data.docs[i]['bath'],
        //       data.docs[i]['beauty'],
        //     ];
        //   }
        setState(() {});
        // }
      }
      //  else {
      //   // 그게 아니면 selectedValue로 데이터 가져오기
      //   var result =
      //       await petsRef.where("name", isEqualTo: selectedValue).get();
      //   if (result.docs.isNotEmpty) {
      //     String dogId = result.docs[0].id;
      //     final calRef = petsRef.doc(dogId).collection('Calendar');
      //     var data = await calRef.get();
      //     for (int i = 0; i < data.docs.length; i++) {
      //       Calendar.events['${data.docs[i].reference.id}/$selectedValue'] = [
      //         data.docs[i]['diary'],
      //         data.docs[i]['bath'],
      //         data.docs[i]['beauty'],
      //       ];
      //     }
      //     setState(() {});
      //     print(Calendar.events);
      //   }
      // }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
  }

  @override
  Widget build(BuildContext context) {
    // var name = controller.name;

    // if (controller.name == '') {
    //   name = '댕댕이 없음';
    // } else {
    //   name = controller.name;
    // }

    return Column(
      children: [
        // appbar로 교체해야함
        // const SizedBox(
        //   height: 100,
        // ),
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
                              // setState(() {
                              controller.date = newDate!;
                              // });

                              // if (newDate == null) return;
                            },
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10, left: 20),
                              child: selectedValue.isEmpty
                                  ? GestureDetector(
                                      child: const Text('멍멍이를 선택해주세요'),
                                      onTap: () {
                                        setState(() {});
                                      },
                                    )
                                  : DropdownButton(
                                      value: selectedValue,
                                      items: controller.valueList.map(
                                        (value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(value),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedValue = value.toString();
                                          // getName();
                                          controller.saveName = selectedValue;
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
