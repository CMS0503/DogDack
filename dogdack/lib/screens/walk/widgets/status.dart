import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/walk_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:dogdack/models/dog_data.dart';

import '../../../controllers/mypage_controller.dart';

class Status extends StatefulWidget {
  const Status({
    Key? key,
  }) : super(key: key);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  final WalkController walkController = Get.put(WalkController());
  final PetController petController = Get.put(PetController());

  Color grey = const Color.fromARGB(255, 80, 78, 91);
  Color violet = const Color.fromARGB(255, 100, 92, 170);
  Color violet2 = const Color.fromARGB(255, 160, 132, 202);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    walkController.getCur();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        // color: violet2,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          // side: BorderSide(color: Colors.black, width: 2)
        ),
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // SizedBox(height: 5,),
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: size.width * 0.2,
                        height: size.width * 0.2,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/dog.jpg'),
                            ),
                            Positioned(
                              bottom: 37,
                              right: 40,
                              child: IconButton(
                                onPressed: () {
                                  walkController.ledSig == '1'
                                      ? walkController.ledSig = '0'
                                      : walkController.ledSig = '1';
                                },
                                icon: walkController.ledSig == '1'
                                    ? const Icon(
                                        Icons.lightbulb_outline,
                                        color: Colors.yellow,
                                      )
                                    : const Icon(
                                        Icons.lightbulb_outline,
                                        color: Colors.yellow,
                                      ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      walkController.isBleConnect.value == true
                          ? IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/Ble');
                              },
                              icon: const Icon(
                                Icons.bluetooth_outlined,
                                color: Colors.blue,
                              ))
                          : IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/Ble');
                              },
                              icon: const Icon(Icons.bluetooth_outlined),
                            ),
                      Text(walkController.name),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: size.width * 0.3,
                        height: size.height * 0.035,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 221, 137, 189),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            "오늘의 목표 시간",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'bmjua',
                                color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Text(
                            walkController.goal.value == 0
                                ? "0 분"
                                : '${walkController.goal} 분',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: size.width * 0.3,
                        height: size.height * 0.035,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 160, 132, 202),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            '목표 산책 달성률',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'bmjua',
                                color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Text(
                            '${walkController.getCur()} %',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
