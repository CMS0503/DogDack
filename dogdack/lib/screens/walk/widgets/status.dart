import 'package:dogdack/controllers/walk_controller.dart';
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
  final PetController petController = Get.put(PetController());
  final WalkController walkController = Get.put(WalkController());

  // final petsRef = FirebaseFirestore.instance.collection('Users/${FirebaseAuth.instance.currentUser!.email.toString()}/Pets')
  //     .withConverter(fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!), toFirestore: (dogData, _) => dogData.toJson());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                            onPressed: () {},
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
                    '권장 산책 시간',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    '1시간',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '목표 산책 달성량',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    '80%',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
