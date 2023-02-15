import 'package:dogdack/models/dog_data.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController extends GetxController {
  bool initFlag = false;
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