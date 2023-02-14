import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/walk_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/mypage_controller.dart';
import '../../../models/dog_data.dart';

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

  final petsRef = FirebaseFirestore.instance.collection('Users/${'imcsh313@naver.com'}/Pets')
      .withConverter(fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!), toFirestore: (dogData, _) => dogData.toJson());


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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                children: [
                  Obx(() =>
                    SizedBox(
                      width: size.width * 0.2,
                      height: size.width * 0.2,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          walkController.selUrl.value.isEmpty
                          ? const CircleAvatar(
                            backgroundImage: AssetImage('assets/dog.jpg'),
                          )
                          :CircleAvatar(
                            child: StreamBuilder(
                              stream: petsRef.snapshots(),
                              builder: (context, snapshot){
                                return CircleAvatar(
                                  radius: size.width * 0.2,
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: walkController.selUrl.value,
                                    ),
                                  )
                                );
                              },
                            )
                          ),
                          Positioned(
                            bottom: 37,
                            right: 40,
                            child: IconButton(
                              onPressed: () {
                                walkController.ledSig = !walkController.ledSig;
                              },
                              icon: const Icon(
                                Icons.lightbulb_outline,
                                color: Colors.yellow,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10,),
              Obx(() =>
              Column(
                  children: [
                    walkController.isBleConnect.value == true
                        ? IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/Ble');
                            },
                            icon: const Icon(Icons.bluetooth_connected))
                        : IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/Ble');
                            },
                            icon: const Icon(Icons.bluetooth_outlined),
                          ),
                    // Text('${walkController.name}'),
                    if(walkController.isSelected.value) ...[
                      DropdownButton<String>(
                        value: walkController.dropdownValue,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? value) {
                          petsRef.where('name', isEqualTo: walkController.dropdownValue).get().then((data) {
                            setState(() {
                              walkController.dropdownValue = value!;
                            });
                          });
                        },
                        items: walkController.selDogs.map<DropdownMenuItem<String>>((dynamic value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ]
                    // walkController.showDropDown(),
                  ],
                ),
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
                    // () => Text(
                    //   walkController.goal == 0
                    //       ? "분"
                    //       : '${walkController.goal} 분',
                    //   style: Theme.of(context).textTheme.displayMedium,
                    // ),
                    () => TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.purple,
                        ),
                        onPressed: () {
                          walkController.goal.value == 0
                          ? null
                          : showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                title: const Text("목표 산책시간 변경"),
                                content: SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(20),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: '현재 목표 산책 시간 : ${walkController.goal.value} 분',
                                        ),
                                        onChanged: (text) {
                                          setState(() {
                                            walkController.tmp_goal.value = int.parse(text);
                                          });
                                        },
                                      )
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text("변경하기"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      // walkController.goal.value = context;
                                      setState(() {
                                        walkController.goal.value = walkController.tmp_goal.value;
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(walkController.goal == 0
                            ? "분"
                            : '${walkController.goal} 분',
                          style: Theme.of(context).textTheme.displayMedium,)
                    )
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
