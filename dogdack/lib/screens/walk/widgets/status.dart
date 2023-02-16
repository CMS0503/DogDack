import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/user_controller.dart';
import 'package:dogdack/controllers/walk_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final UserController userController = Get.put(UserController());

  late CollectionReference<DogData> petsRef;

  Color grey = const Color.fromARGB(255, 80, 78, 91);
  Color violet = const Color.fromARGB(255, 100, 92, 170);
  Color violet2 = const Color.fromARGB(255, 160, 132, 202);

  bool isInt = false;

  @override
  Widget build(BuildContext context) {
    petsRef = FirebaseFirestore.instance.collection('Users/${userController.loginEmail}/Pets')
        .withConverter(fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!), toFirestore: (dogData, _) => dogData.toJson());

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
                      Obx(() => SizedBox(
                        width: size.width * 0.2,
                        height: size.width * 0.2,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            walkController.selUrl.value.isEmpty
                            ? const CircleAvatar(
                              backgroundImage:
                                            AssetImage('assets/logo.jpg'),
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
                    ),
                  ],
                ),
                const SizedBox(width: 10,),
                Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            walkController.isBleConnect.value == true
                                ? IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/Ble');
                                    },
                                    icon: const Icon(
                                      Icons.bluetooth_outlined,
                                      color: Color.fromARGB(255, 100, 92, 170),
                                    ))
                                : IconButton(
                                    onPressed: () {Navigator.pushNamed(context, '/Ble');},
                      icon: const Icon(Icons.bluetooth_outlined),
                    ),
                    // Text('${walkController.name}'),
                    if(walkController.isSelected.value) ...[
                      DropdownButton<String>(
                        underline: const SizedBox.shrink(),
                                value: walkController.dropdownValue,
                                elevation: 16,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: 'bmjua',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16),
                                // underline: Container(
                                //   height: 2,
                                //   color: Colors.deepPurpleAccent,
                                // ),
                                onChanged: (String? value) {
                                  petsRef
                                      .where('name', isEqualTo: value)
                                      .get()
                                      .then((data) {
                                    setState(() {
                                      walkController.dropdownValue = value!;
                                      walkController.selUrl.value =
                                          data.docs[0].get('imageUrl');
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
                  ],
                  )
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
                          color: const Color.fromARGB(255, 221, 137, 189),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
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
                        child: TextButton(
                            style: TextButton.styleFrom(
                                    foregroundColor: Colors.purple,
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                                              padding: const EdgeInsets.all(20),
                                              child: TextField(
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: '현재 목표 산책 시간 : ${walkController.goal.value} 분',
                                                ),
                                                onChanged: (text) {
                                                  if(int.tryParse(text) != null) {
                                                    isInt = true;
                                                    walkController.tmp_goal.value = int.parse(text);
                                                  } else {
                                                    isInt = false;
                                                  }
                                                },
                                              )
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: const Text("변경하기"),
                                          onPressed: () {
                                            if(isInt){
                                              Navigator.pop(context);
                                              walkController.goal.value = walkController.tmp_goal.value;
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (BuildContext context){
                                                    return AlertDialog(
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                                      title: const Text("올바른 숫자를 입력하세요"),
                                                      actions: <Widget> [
                                                        Align(
                                                          alignment: Alignment.center,
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                            child: const Text("확인"),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                            },
                            child: Text(walkController.goal == 0 ? "분" : '${walkController.goal} 분',
                            style: Theme.of(context).textTheme.displayMedium,)
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: size.width * 0.3,
                      height: size.height * 0.035,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 160, 132, 202),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
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
          )
        ),
      ),
    );
  }
}
