import 'package:dogdack/screens/my/widgets/mypage_snackbar.dart';
import 'package:flutter/material.dart';

// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

// GetX
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'controller/mypage_controller.dart';

// model
import '../../models/dog_data.dart';

// File
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:intl/intl.dart';

class EditDogInfoPage extends StatefulWidget {
  const EditDogInfoPage({Key? key}) : super(key: key);

  @override
  State<EditDogInfoPage> createState() => _EditDogInfoPageState();
}

class _EditDogInfoPageState extends State<EditDogInfoPage> {
  // Firebase : 반려견 테이블 참조 값
  final petsRef = FirebaseFirestore.instance.collection('Users/${FirebaseAuth.instance.currentUser!.email.toString()}/Pets')
      .withConverter(fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!), toFirestore: (dogData, _) => dogData.toJson());

  // GetX
  final petController = Get.put(PetController());
  final mypageStateController = Get.put(MyPageStateController());

  // 강아지 정보
  String name = ""; // 이름
  List gender = ['Male', 'Female']; // 성별 리스트
  String selectGender = 'Male'; // 성별 초기 값
  String birth = '여기를 눌러 생일을 추가해주세요!'; // 생일
  String breed = '미지정'; // 견종
  String imageUrl = ''; // 이미지 URL

  // 성별 선택 Radio button 관련 위젯
  Row addRadioButton(int btnValue, String title) {
    return Row(
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: selectGender,
          onChanged: (value) {
            FocusManager.instance.primaryFocus?.unfocus();
            setState(() {
              selectGender = value;
            });
          },
        ),
        title.compareTo('Male') == 0
            ? Icon(Icons.male, color: Colors.blueAccent,)
            : Icon(Icons.female, color: Colors.pink,),
      ],
    );
  }

  // 강아지 이미지 선택
  File dogImg = File(''); // 강아지 이미지 파일
  final picker = ImagePicker(); // 갤러리에서 가져오기 위한 ImagePicker
  bool pickComp = false; // 사진 선택 완료 여부 확인. 사진 추가 이미지를 선택한 이미지로 변경하기 위함

  chooseImage() async {
    // 갤러리에서 사진을 가져옴
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile == null) return;

    // 가져온 사진을 원형으로 잘라냄
    var file = await ImageCropper().cropImage(
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      sourcePath: pickedFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.circle,
    );

    if (file == null) {
      return;
    }

    //선택 완료
    setState(() => dogImg = File(file.path));
    if (file.path == null) retrieveLostData();
    if (dogImg != null) {
      pickComp = true;
      if(mypageStateController.myPageStateType == MyPageStateType.Edit) {
        isChangeImg = true;
      }
    }
  }

  // 이미지 파일 저장 실패시 재시도?
  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() => dogImg = File(response.file!.path));
    } else {
      print(response.file);
    }
  }

  // 강아지 정보 데이터 삭제
  Future<void> _delete([DocumentSnapshot? documentSnapshot]) async {
    await petsRef
        .doc(petController.selectedPetID)
        .delete()
        .whenComplete(() => print('삭제 완료'))
        .catchError((error) => print(error));
  }

  // 강아지 정보 데이터 수정
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if(isChangeImg) {
      // 이미지 파일이 변경되었다면 기존 사진 데이터 제거
      FirebaseStorage.instance.ref().child('${FirebaseAuth.instance.currentUser!.email.toString()}/dogs/${petController.selectedPetImageFileName}').delete();
    }

    Reference petImgRef = FirebaseStorage.instance.ref().child(
        '${FirebaseAuth.instance.currentUser!.email.toString()}/dogs/${Path.basename(dogImg!.path)}');

    print('update 시도함');

    await petImgRef!.putFile(dogImg!).whenComplete(() async {
      await petImgRef!.getDownloadURL().then((value) {
        var map = Map<String, dynamic>();
        map["name"] = name;
        map["gender"] = selectGender;
        map["breed"] = breed;
        map["imageUrl"] = imageUrl;
        map["birth"] = birth;
        map["imageFileName"] = Path.basename(dogImg!.path);

        petsRef
            .doc(petController.selectedPetID)
            .update(map)
            .whenComplete(() => print("변경 완료"))
            .catchError((error) => print(error));
      });
    });
  }

  // 강아지 정보 데이터 추가
  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    // 강아지 이미지 파일 저장 경로
    Reference petImgRef = FirebaseStorage.instance.ref().child(
        '${FirebaseAuth.instance.currentUser!.email.toString()}/dogs/${Path.basename(dogImg!.path)}');

    await petImgRef!.putFile(dogImg!).whenComplete(() async {
      await petImgRef!.getDownloadURL().then((value) {
        //이미지 경로를 db 에 저장
        petsRef.add(DogData(
          name: name,
          gender: selectGender,
          birth: birth,
          breed: breed,
          createdAt: Timestamp.now(),
          imageUrl: value,
          imageFileName: Path.basename(dogImg!.path),
        )).then((value) => print('강아지 정보 저장 완료'))
            .catchError((error) => print('강아지 정보 저장 오류! ${petsRef}'));
      });
    });
  }

  // 상태 확인을 위한 boolean 변수
  bool uploadingImg = false; // 이미지 업로드 여부 => 사진을 추가가 진행되는 중에 다시 추가 버튼을 누를 경우 동작하지 않도록 함
  bool createData = false; // 데이터 생성 완료 여부
  bool uploadingData = false; // 데이터 업로드 여부 => 버튼을 누르는 순간 다시 동작 못하게 하기 위함.
  bool editingData = false; // 데이터 수정/삭제 여부 => 버튼을 누르는 순간 다시 동작 못하게 하기 위함.
  bool selectedBirth = false; // 생일 선택 완료 확인
  bool isChangeImg = false; // 편집 모드에서 기존 사진을 변경 완료했는지 여부

  // 생일 선택
  Future _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selected != null) {
      setState(() {
        String year = (DateFormat.y()).format(selected);
        String month = (DateFormat.M()).format(selected);
        String day = (DateFormat.d()).format(selected);

        birth = '${year}.${month}.${day}';
        selectedBirth = true;
      });
    }
  }

  // 텍스트 폼을 위한 글로벌 키
  // 이 키는 나중에 폼 내부의 TextFormField 값들을 저장하고 validation 을 진행하는데 사용됨.
  final formkey = GlobalKey<FormState>();

  // 편집 모드 일 경우 기존 데이터를 텍스트 폼에 띄우기 위함.
  TextEditingController _nameController = TextEditingController();
  TextEditingController _breedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (mypageStateController.myPageStateType == MyPageStateType.Edit) {
      pickComp = true; // 사진이 골라져있음

      _nameController = TextEditingController(text: petController.selectedPetName);
      _breedController = TextEditingController(text: petController.selectedPetBreed);
      birth = petController.selectedPetBirth;
      selectGender = petController.selectedPetGender;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 신규 생성일 경우 초기화 데이터 입력
    //_createDefaultPetInfo();

    // 디바이스 사이즈 크기 정의
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        // 폼 이외의 위치를 탭하면 키보드 해제
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            mypageStateController.myPageStateType == MyPageStateType.Create ? '추가하기' : '편집하기',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // 위젯이 화면 밖으로 벗어날 경우 오버플로우가 나지 않기 위함
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.05,
              ),
              // 반려견 이미지
              InkWell(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: size.width * 0.2,
                      child: pickComp
                          ? ClipOval(child: mypageStateController.myPageStateType == MyPageStateType.Create
                            ? Image(image: FileImage(dogImg))
                            : Image.network(petController.selectedPetImageUrl),)
                          : Icon(Icons.add, size: size.width * 0.2,),
                    ),
                  ],
                ),
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  !uploadingImg ? chooseImage() : null;
                },
              ),
              SizedBox(height: 15),
              // 강아지 정보
              Center(
                child: Container(
                  height: size.height * 0.5,
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        blurRadius: 5.0,
                        spreadRadius: 0.0,
                        offset: const Offset(0, 7),
                      )
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Padding(
                      // 정보 입력 칸 내의 모든 위젯 상하좌우 여백
                      padding: EdgeInsets.fromLTRB(size.width * 0.05, size.width * 0.05, size.width * 0.05, 0),
                      child: Form(
                        key: this.formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 이름
                            Row(
                              children: [
                                Text(
                                  '이름  ',
                                  style: TextStyle(
                                    color: Colors.deepPurpleAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                CircleAvatar(
                                  child: Icon(
                                    Icons.edit,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  backgroundColor: Colors.black,
                                  radius: 10,
                                ),
                              ],
                            ),
                            Container(
                              height: 50,
                              child: TextFormField(
                                onSaved: (value) {
                                  name = value!;
                                },
                                onChanged: (value) {
                                  name = value!;
                                },
                                decoration: InputDecoration(
                                  hintText: '이름을 입력하세요!',
                                ),
                                controller: _nameController,
                              ),
                            ),
                            SizedBox(height: 10),
                            // 성별
                            Row(
                              children: [
                                Text(
                                  '성별  ',
                                  style: TextStyle(
                                    color: Colors.deepPurpleAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                CircleAvatar(
                                  child: Icon(
                                    Icons.edit,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  backgroundColor: Colors.black,
                                  radius: 10,
                                )
                              ],
                            ),
                            Container(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  addRadioButton(0, 'Male'),
                                  addRadioButton(1, 'Female'),
                                ],
                              ),
                            ),
                            // 생일
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '생일  ',
                                      style: TextStyle(
                                        color: Colors.deepPurpleAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    CircleAvatar(
                                      child: Icon(
                                        Icons.edit,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      backgroundColor: Colors.black,
                                      radius: 10,
                                    )
                                  ],
                                ),
                                Center(
                                  child: TextButton(
                                    onPressed: () async {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      await _selectDate(context);
                                    },
                                    child: Text(
                                      birth,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // 견종
                            Row(
                              children: [
                                Text(
                                  '견종  ',
                                  style: TextStyle(
                                    color: Colors.deepPurpleAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                CircleAvatar(
                                  child: Icon(
                                    Icons.edit,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  backgroundColor: Colors.black,
                                  radius: 10,
                                ),
                              ],
                            ),
                            Container(
                              height: 50,
                              child: TextFormField(
                                onSaved: (value) {
                                  breed = value!;
                                },
                                onChanged: (value) {
                                  breed = value!;
                                },
                                decoration: InputDecoration(
                                  hintText: '견종을 입력하세요!',
                                ),
                                controller: _breedController,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // 버튼
                            mypageStateController.myPageStateType == MyPageStateType.Create
                                ? Center(child: !uploadingData
                                  ? ElevatedButton(onPressed: !uploadingData
                                    ? () async {
                                    // 키보드 해제
                                    FocusManager.instance.primaryFocus?.unfocus();

                                    // 버튼 중복 클릭 시 재호출 방지
                                    if (uploadingData) return;

                                    setState(() {
                                      uploadingData = true;
                                    });

                                    // 사진을 등록 하지 않을 경우 알림
                                    if (!pickComp) {
                                      MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.ImageNotExist);
                                      uploadingData = false;
                                      return;
                                    }

                                    // 이름을 등록 하지 않을 경우 알림
                                    if (name.length == 0) {
                                      MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.NameNotExist);
                                      uploadingData = false;
                                      return;
                                    }

                                    // 생일을 선택하지 않은 경우
                                    if (!selectedBirth) {
                                      MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.BirthNotExist);
                                      uploadingData = false;
                                      return;
                                    }

                                    // 견종을 입력하지 않은 경우
                                    if(breed.length == 0) {
                                      MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.BreedNotExist);
                                      uploadingData = false;
                                      return;
                                    }

                                    await _create().whenComplete(() {
                                      if (Navigator.canPop(context))
                                        Navigator.pop(context);
                                    });

                                    setState(() {
                                      createData = true;
                                      uploadingData = false;
                                    });
                                  }
                                    : null,
                                  child: Text('등록하기'))
                                  : CircularProgressIndicator(),
                            )
                                : !editingData
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          onPressed: ! editingData
                                              ? () async {
                                                FocusManager.instance.primaryFocus?.unfocus();

                                                // 버튼 중복 클릭 시 재호출 방지
                                                if (editingData) return;

                                                setState(() {
                                                  editingData = true;
                                                });

                                                // 사진을 등록 하지 않을 경우 알림
                                                if (!pickComp) {
                                                  MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.ImageNotExist);
                                                  editingData = false;
                                                  return;
                                                }

                                                // 이름을 등록 하지 않을 경우 알림
                                                if (name.length == 0) {
                                                  MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.NameNotExist);editingData = false;
                                                  return;
                                                }

                                                // 생일을 선택하지 않은 경우
                                                if (!selectedBirth) {
                                                  MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.BirthNotExist);
                                                  editingData = false;
                                                  return;
                                                }

                                                // 견종을 입력하지 않은 경우
                                                if(breed.length == 0) {
                                                  MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.BreedNotExist);
                                                  editingData = false;
                                                  return;
                                                }

                                                await _update().whenComplete(() {
                                                  if (Navigator.canPop(context))
                                                    Navigator.pop(context);

                                                  setState(() {
                                                    editingData = false;
                                                  });
                                                });}
                                              : null,
                                          child: Text('변경하기'),
                                        ),
                                        ElevatedButton(
                                          onPressed: ! editingData
                                              ? () async {
                                                FocusManager.instance.primaryFocus?.unfocus();

                                                // 버튼 중복 클릭 시 재호출 방지
                                                if (editingData) return;

                                                setState(() {
                                                  editingData = true;
                                                });

                                                await _delete().whenComplete(() {
                                                  if (Navigator.canPop(context))
                                                    Navigator.pop(context);

                                                  petController.selectedPetScrollIndex = petController.selectedPetScrollIndex - 1;
                                                  if(petController.selectedPetScrollIndex < 0) petController.selectedPetScrollIndex = 0;

                                                  setState(() {
                                                    editingData = false;
                                                  });
                                                });
                                  }
                                              : null,
                                          child: Text('삭제하기'),
                                ),
                              ],
                            )
                                  : CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
