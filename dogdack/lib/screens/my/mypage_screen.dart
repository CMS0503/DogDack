import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

// import '../../models/user_data.dart';

class MyPage extends StatelessWidget {
  MyPage({super.key, required this.tabIndex});
  final inputController = TextEditingController();
  final int tabIndex;

  // void fbstoreWrite() {
  //   FirebaseFirestore.instance
  //       .collection(FirebaseAuth.instance.currentUser!.email.toString())
  //       .withConverter(
  //         fromFirestore: (snapshot, options) =>
  //             UserData.fromJson(snapshot.data()!),
  //         toFirestore: (value, options) => value.toJson(),
  //       )
  //       .add(UserData(
  //           userText: inputController.text, createdAt: Timestamp.now()))
  //       .then((value) => print("document added"))
  //       .catchError((error) => print("Fail to add doc $error"));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("My Page")),
        body: SafeArea(
          child: Column(children: [
            Text("안녕! ${FirebaseAuth.instance.currentUser!.email}"),
            const UserImageWidget(),
            TextButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                child: const Text("로그아웃")),
            TextField(
              controller: inputController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text("텍스트를 입력하세요.")),
            ),
            // ElevatedButton(
            //     onPressed: () => fbstoreWrite(),
            //     child: const Text("Text Upload")),
            // const FirestoreRead(),
          ]),
        ));
  }
}

class UserImageWidget extends StatefulWidget {
  const UserImageWidget({Key? key}) : super(key: key);

  @override
  State<UserImageWidget> createState() => _UserImageWidgetState();
}

class _UserImageWidgetState extends State<UserImageWidget> {
  String imageUrl = '';
  final inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return UserImage(onFileChanged: (imageUrl) {
      setState(() {
        this.imageUrl = imageUrl;
      });
    });
  }
}

/*class MyPage extends StatelessWidget {
  MyPage({super.key, required this.tabIndex});

  final int tabIndex;
  final inputController = TextEditingController();

  void fbstoreWrite() {
    FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.email.toString())
        .withConverter(
      fromFirestore: (snapshot, options) =>
          UserData.fromJson(snapshot.data()!),
      toFirestore: (value, options) => value.toJson(),
    )
        .add(UserData(
        userText: inputController.text, createdAt: Timestamp.now()))
        .then((value) => print("document added"))
        .catchError((error) => print("Fail to add doc ${error}"));
  }

  Future setUserImage(ImageSource imageSource) async {
    ImagePicker imagePicker = ImagePicker();

    try {
      //image picker 를 통해 image 선택
      var tempImage = await imagePicker.pickImage(source: imageSource);
      if(tempImage != null) {
        ImageCropper().cropImage(
          cropStyle: CropStyle.circle,
          sourcePath: tempImage.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1), //crop 비율 1:1
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: '이미지 편집',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true,
            ),
            IOSUiSettings(
              title: '이미지 편집',
              aspectRatioLockEnabled: true,
              resetAspectRatioEnabled: false,
            )
          ],
        ).then((croppedImage) { //image 자르기가 완료되었으면
          if(croppedImage != null) {
            //잘린 이미지를 저장
            _userNewImage.value = File(croppedImage.path);
          }
          Get.back();
        });
      }

    } catch (e) {
      print(e);
      Get.back();
    }
  }

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("My Page")),
        body: SafeArea(
          child: Column(children: [
            Text("안녕! ${FirebaseAuth.instance.currentUser!.email}"),
            Text("from tab: ${tabIndex.toString()}"),
            UserImage(
              onFileChanged: (imageUrl) {
                setState(() {
                  this.imageUrl = imageUrl;
                });
              }
            ),
            TextButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                child: Text("로그아웃")),
            TextField(
              controller: inputController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), label: Text("텍스트를 입력하세요.")),
            ),
            ElevatedButton(
                onPressed: () => fbstoreWrite(), child: Text("Text Upload")),
            FirestoreRead(),
          ]),
        ));
  }
}*/

class UserImage extends StatefulWidget {
  final Function(String imageUrl) onFileChanged;

  const UserImage({required this.onFileChanged});

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  final ImagePicker _picker = ImagePicker();

  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imageUrl == null)
          Icon(
            Icons.image,
            size: 68,
            color: Theme.of(context).primaryColor,
          ),
        if (imageUrl != null)
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => _selectPhoto(),
            child: AppRoundImage.url(
              imageUrl!,
              width: 80,
              height: 80,
            ),
          ),
        InkWell(
          onTap: () => _selectPhoto(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              imageUrl != null ? 'Change photo' : 'Select photo',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }

  Future _selectPhoto() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text('Camera'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.filter),
                    title: const Text('Pick a file'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              onClosing: () {},
            ));
  }

  Future _pickImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile == null) {
      return;
    }

    var file = await ImageCropper().cropImage(
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    if (file == null) {
      return;
    }

    await _uploadFile(file.path);
  }

  Future _uploadFile(String path) async {
    final ref = storage.FirebaseStorage.instance
        .ref()
        .child('image')
        .child(DateTime.now().toIso8601String() + p.basename(path));

    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {
      imageUrl = fileUrl;
    });

    widget.onFileChanged(fileUrl);
  }
}

class AppRoundImage extends StatelessWidget {
  final ImageProvider provider;
  final double height;
  final double width;

  const AppRoundImage(
    this.provider, {
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Image(
        image: provider,
        height: height,
        width: width,
      ),
    );
  }

  factory AppRoundImage.url(
    String url, {
    required double height,
    required double width,
  }) {
    return AppRoundImage(
      NetworkImage(url),
      height: height,
      width: width,
    );
  }

  factory AppRoundImage.memory(
    Uint8List data, {
    required double height,
    required double width,
  }) {
    return AppRoundImage(
      MemoryImage(data),
      height: height,
      width: width,
    );
  }
}

// class FirestoreRead extends StatefulWidget {
//   const FirestoreRead({super.key});

//   @override
//   State<FirestoreRead> createState() => _FirestoreReadState();
// }

// class _FirestoreReadState extends State<FirestoreRead> {
//   final userTextColRef = FirebaseFirestore.instance
//       .collection(FirebaseAuth.instance.currentUser!.email.toString())
//       .withConverter(
//           fromFirestore: (snapshot, _) => UserData.fromJson(snapshot.data()!),
//           toFirestore: (movie, _) => movie.toJson());

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: userTextColRef.orderBy('createdAt').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Text("There is no data!");
//         }
//         if (snapshot.hasError) {
//           return const Text("Failed to read the snapshot");
//         }

//         return Expanded(
//           child: ListView(
//             //리스트뷰 써보자! 왜냐면 데이터가 많을 거니까!
//             shrinkWrap: true, //이거 없으면 hasSize에서 에러발생!!
//             //snapshot을 map으로 돌려버림!
//             children: snapshot.data!.docs.map((document) {
//               return Column(children: [
//                 const Divider(
//                   thickness: 2,
//                 ),
//                 ListTile(title: Text(document.data().userText!))
//               ]); //Listtile 생성!
//             }).toList(), //map을 list로 만들어서 반환!
//           ),
//         );
//       },
//     );
//   }
// }
