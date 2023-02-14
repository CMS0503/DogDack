import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogdack/controllers/input_controller.dart';
import 'package:dogdack/controllers/user_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

class ScheduleEditImage extends StatefulWidget {
  const ScheduleEditImage({super.key});

  @override
  State<ScheduleEditImage> createState() => _ScheduleEditImageState();
}

class _ScheduleEditImageState extends State<ScheduleEditImage> {
  // firebase storage 불러오기
  FirebaseStorage storage = FirebaseStorage.instance;
  final controller = Get.put(InputController());
  final userController = Get.put(UserController());

  // 이미지 업로드 (카메라 / 갤러리)
  Future<void> _upload(String inputSource) async {
    final picker = ImagePicker();
    XFile? pickedImage;
    try {
      pickedImage = await picker.pickImage(
        source:
            inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1920,
        imageQuality: 50,
      );

      if (pickedImage == null) {
        return;
      }

      final String fileName = path.basename(pickedImage.path);
      // print('pickedImage.path : ${pickedImage.path}');
      File imageFile = File(pickedImage.path);

      try {
        // Uploading the selected image with some custom meta data
        final result = await storage
            .ref()
            .child(
                '${userController.loginEmail}/dogs/${controller.selectedValue}/${controller.date}/$fileName')
            .putFile(
              imageFile,
              SettableMetadata(
                customMetadata: {
                  'uploaded_by': 'A bad guy',
                  'description': 'Some description...'
                },
              ),
            );
        result.ref.getDownloadURL().then((value) {
          controller.imageUrl.add(value.toString());
          // print('이미지 url');
          // print(controller.imageUrl);
        });

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

  // Retriew the uploaded images
  // This function is called when the app launches for the first time or when an image is uploaded or deleted
  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage
        .ref()
        .child(
            '${userController.loginEmail}/dogs/${controller.selectedValue}/${controller.date}')
        .list();
    final List<Reference> allFiles = result.items;

    final snapshot = await FirebaseFirestore.instance
        .collection(
          'Users',
        )
        .doc(userController.loginEmail)
        .collection('Calendar')
        .doc(DateFormat('yyMMdd').format(controller.date))
        .get();

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      // print('$fileUrl, ${file.fullPath}');
      if (controller.imageUrl.contains(fileUrl)) {
        files.add({
          "url": fileUrl,
          "path": file.fullPath,
          "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
          "description":
              fileMeta.customMetadata?['description'] ?? 'No description'
        });
      }
    });

    return files;
  }

  // Delete the selected image
  // This function is called when a trash icon is pressed
  Future<void> _delete(String ref, String url) async {
    await storage.ref(ref).delete();
    controller.imageUrl.remove(url);
    print('controller.imageUrl ${controller.imageUrl}');
    // Rebuild the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 35,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 100, 92, 170),
                  ),
                  onPressed: () => {
                    _upload('camera'),
                  },
                  icon: const Icon(
                    Icons.camera,
                  ),
                  label: const Text('카메라'),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 35,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 100, 92, 170),
                  ),
                  onPressed: () {
                    _upload('gallery');
                  },
                  icon: const Icon(
                    Icons.library_add,
                  ),
                  label: const Text('갤러리'),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            alignment: Alignment.center,
            height: height * 0.37,
            width: width * 0.85,
            child: FutureBuilder(
              future: _loadImages(),
              builder: (context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data!.isNotEmpty) {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            separatorBuilder: ((context, index) =>
                                const SizedBox(
                                  width: 20,
                                )),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              final Map<String, dynamic> image =
                                  snapshot.data![index];
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: width * 0.8,
                                    height: height * 0.3,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        20,
                                      ),
                                      child: Image.network(
                                        image['url'],
                                        fit: BoxFit.cover,
                                        // width: width,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 30,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 228, 31, 31),
                                        ),
                                        child: Row(
                                          children: const [
                                            Text(
                                              '사진 삭제',
                                              style: TextStyle(
                                                fontFamily: 'bmjua',
                                                color: Colors.white,
                                              ),
                                            ),
                                            // Icon(
                                            //   Icons.delete_outlined,
                                            //   color: Colors.white,
                                            // ),
                                          ],
                                        ),
                                        onPressed: () => _delete(
                                          image['path'],
                                          image['url'],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    print(snapshot.hasData);
                    return Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 229, 229, 230),
                        border: Border(),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      height: height * 0.3,
                      width: width * 0.8,
                      child: const Icon(Icons.add_photo_alternate_outlined,
                          size: 80, color: Color.fromARGB(255, 147, 147, 147)),
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
