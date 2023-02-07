import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/screens/calendar_schedule_edit/controller/input_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarDrop extends StatefulWidget {
  const CalendarDrop({super.key});

  @override
  State<CalendarDrop> createState() => _CalendarDropState();
}

class _CalendarDropState extends State<CalendarDrop> {
  final controller = Get.put(InputController());
  // late List<String> valueList = ["짬뽕", "공숙"];
  // String selectedValue = '안뇽';
  // final valueList = ['첫 번째', '두 번째', '세 번째', '네 번째'];
  // var selectedValue = '첫 번째';
  final petsRef = FirebaseFirestore.instance
      .collection('Users/${FirebaseAuth.instance.currentUser!.email}/Pets');

  getName() async {
    var names = await petsRef.get();

    List<String> dogs = [];

    for (int i = 0; i < names.docs.length; i++) {
      dogs.insert(0, names.docs[i]['name']);
    }

    setState(() {
      controller.dognames = dogs;
    });
  }

  @override
  void initState() {
    super.initState();
    getName();
    print('${controller.dognames} sdfsdfewiruqrioqfjnsdklfmksl');
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    var valueList = controller.dognames;
    var selectedValue = '';

    if (valueList.isEmpty) {
      valueList = ['댕댕이를 등록하세요'];
      selectedValue = '댕댕이를 등록하세요';
    } else {
      selectedValue = valueList[0];
    }

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20),
          child: SizedBox(
            height: height * 0.05,
            child: DropdownButton(
              underline: Container(),
              value: selectedValue,
              items: valueList.map(
                (value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 100, 92, 170),
                        fontFamily: 'bmjua',
                        fontSize: 20,
                      ),
                    ),
                  );
                },
              ).toList(),
              onChanged: (value) {
                setState(
                  () {
                    selectedValue = value.toString();
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
