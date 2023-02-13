import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/dog_data.dart';

class CollectionController extends GetxController {
  CollectionReference<DogData> petsRef = FirebaseFirestore.instance
      .collection('Users/${FirebaseAuth.instance.currentUser!.email}/Pets')
      .withConverter(
      fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!),
      toFirestore: (dogData, _) => dogData.toJson());
}