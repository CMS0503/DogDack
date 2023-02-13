import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/walk_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

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

  // final petsRef = FirebaseFirestore.instance.collection('Users/${userController.loginEmail}/Pets')
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
  //       .collection('Users/${userController.loginEmail}/Pets')
  //
  //
  //   imageurl = walkController.ImageURL.toString();
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    walkController.getCur();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
                  Text(
                    '목표 산책 시간',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Obx(
                    () => Text(
                      walkController.goal == 0
                          ? "목표 산책 시간을 입력해 주세요"
                          : '${walkController.goal} 분',
                      style: Theme.of(context).textTheme.displayMedium,
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
                  Text(
                    '목표 산책 달성률',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Obx(
                    () => Text(
                      '${walkController.getCur()} %',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
