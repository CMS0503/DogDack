import 'package:dogdack/models/dog_data.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController extends GetxController {
  bool initFlag = false; // 최초 접근 이후 다시 수행되지 못하도록 하는 플래그. main.dart 에서 사용됨.
  bool isHost = false;
  String loginEmail = '';

  var userRef;

  Future<void> updateUserInfo() async {
    if (loginEmail.length > 1) {
      userRef = FirebaseFirestore.instance
          .collection('Users/$loginEmail/Pets')
          .withConverter(
              fromFirestore: (snapshot, _) =>
                  DogData.fromJson(snapshot.data()!),
              toFirestore: (dogData, _) => dogData.toJson());
    }

    // update();
  }

  Future<void> myUpdate() async {
    await updateUserInfo();
    update();
  }
}