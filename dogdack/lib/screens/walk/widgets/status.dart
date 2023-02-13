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

  // final petsRef = FirebaseFirestore.instance.collection('Users/${'imcsh313@naver.com'}/Pets')
  //     .withConverter(fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!), toFirestore: (dogData, _) => dogData.toJson());

  // String imageurl = "";
  //
  // @override
  // void initState() {
  //   super.initState();
  //
  //   setUrl().then((result) {
  //     setState(() {});
  //   });
  // }
  //
  // Future<void> setImageUrl () async {
  //   var documentSnapshot = await FirebaseFirestore.instance
  //       .collection('Users/${'imcsh313@naver.com'}/Pets')
  //
  //
  //   imageurl = walkController.ImageURL.toString();
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    walkController.getCur();
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
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
                                walkController.ledSig = !walkController.ledSig;
                              },
                              icon: Icon(
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
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    walkController.isBleConnect == true
                        ? IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/Ble');
                            },
                            icon: Icon(Icons.bluetooth_connected))
                        : IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/Ble');
                            },
                            icon: Icon(Icons.bluetooth_outlined),
                          ),
                    Text('${walkController.name}'),
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
                          walkController.goal == 0
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
    );
  }
}
