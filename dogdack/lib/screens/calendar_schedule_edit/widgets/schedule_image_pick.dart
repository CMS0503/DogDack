import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';

class ScheduleImagePick extends StatefulWidget {
  const ScheduleImagePick({super.key});

  @override
  State<ScheduleImagePick> createState() => _ScheduleImagePickState();
}

class _ScheduleImagePickState extends State<ScheduleImagePick> {
  // firebase storage 불러오기
  FirebaseStorage storage = FirebaseStorage.instance;

  // 이미지 업로드 (카메라 / 갤러리)
  Future<void> _upload(String inputSource) async {
    final picker = ImagePicker();
    XFile? pickedImage;
    try {
      pickedImage = await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920);

      final String fileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path);

      try {
        // Uploading the selected image with some custom meta data
        await storage.ref(fileName).putFile(
            imageFile,
            SettableMetadata(customMetadata: {
              'uploaded_by': 'A bad guy',
              'description': 'Some description...'
            }));
        // Refresh the UI
        setState(() {});
      } on FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 100, 92, 170),
              ),
              onPressed: () => {
                _upload('camera'),
                Navigator.of(context).pop(),
              },
              icon: const Icon(
                Icons.camera,
              ),
              label: const Text('카메라 촬영하기'),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 100, 92, 170),
              ),
              onPressed: () =>
                  {_upload('gallery'), Navigator.of(context).pop()},
              icon: const Icon(
                Icons.library_add,
              ),
              label: const Text('갤러리에서 찾기'),
            ),
          ),
        ],
      ),
    );
  }
}
