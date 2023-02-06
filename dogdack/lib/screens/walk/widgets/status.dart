import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

import '../../my/controller/mypage_controller.dart';
import '../../../models/dog_data.dart';

class Status extends StatefulWidget {
  const Status({
    Key? key,
  }) : super(key: key);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  final PetController petController = Get.put(PetController());

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
              SizedBox(
                width: size.width * 0.25,
                height: size.width * 0.25,
                child: CircularProfileAvatar(
                  'https://firebasestorage.googleapis.com/v0/b/dogdack-4bcfe.appspot.com/o/tyms0503%40gmail.com%2Fdogs%2F20221215_192126%20(1).jpg?alt=media&token=9efee092-a080-45d5-8c6b-48fdeb30783e',
                  //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
                  radius: 100,
                  // sets radius, default 50.0
                  backgroundColor: Colors.transparent,
                  // sets background color, default Colors.white
                  borderWidth: 4,
                  // sets initials text, set your own style, default Text('')
                  borderColor: Theme.of(context).primaryColor,
                  // sets border color, default Colors.white
                  elevation: 5.0,
                  //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
                  cacheImage: true,
                  showInitialTextAbovePicture:
                      true, // setting it true will show initials text above profile picture, default false
                ),
              ),
              const Text('name'),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/Ble');
                  },
                  icon: const Icon(Icons.bluetooth_outlined)),
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
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    '1시간',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '목표 산책 달성량',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
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
