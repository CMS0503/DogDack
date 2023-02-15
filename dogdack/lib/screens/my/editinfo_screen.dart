import 'package:cached_network_image/cached_network_image.dart';
import 'package:dogdack/controllers/input_controller.dart';
import 'package:flutter/material.dart';

// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_picker/picker.dart';

// GetX
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controllers/mypage_controller.dart';

// Model
import '../../controllers/user_controller.dart';
import '../../models/dog_data.dart';

// Image File
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

// Widget
import 'package:dogdack/screens/my/widgets/mypage_snackbar.dart';
import 'package:dogdack/screens/my/widgets/mypage_kategorie_guide.dart';

// DateFormat
import 'package:intl/intl.dart';

class EditDogInfoPage extends StatefulWidget {
  const EditDogInfoPage({Key? key}) : super(key: key);

  @override
  State<EditDogInfoPage> createState() => _EditDogInfoPageState();
}

class _EditDogInfoPageState extends State<EditDogInfoPage> {
  final userController = Get.put(UserController());

  // Firebase : 반려견 테이블 참조 값
  late final petsRef;

  // GetX
  final petController = Get.put(PetController());
  final mypageStateController = Get.put(MyPageStateController());
  final homeSliderController = Get.put(HomePageSliderController());
  final inputController = Get.put(InputController());

  // 강아지 정보 : (GetX 강아지 정보 관련 변수는 조회 페이지에서 선택한 정보이기 때문에 다르게 관리함)
  final kategorieList = [
    ['논스포팅', '시각 하운드', '후각 하운드', '테리어', '허딩', '토이', '스포팅', '워킹']
  ]; // 견종 카테고리 리스트
  final weightList = [[]];
  List genderList = ['Male', 'Female']; // 성별 리스트

  String imageUrl = ''; // 이미지 URL
  String imageFileName = ''; // 이미지 파일 이름
  String name = ""; // 이름
  String gender = 'Male'; // 성별 초기 값
  String birth = '여기를 눌러 생일을 추가해주세요!'; // 생일
  String kategorie = '여기를 눌러 카테고리를 추가해주세요!'; // 견종 카테고리
  String breed = '미지정'; // 견종
  num weight = 0; // 몸무게
  num recommend = 0; // 일일 권장 산책 시간

  // 성별 선택 Radio button 관련 위젯
  Row addRadioButton(int btnValue, String title) {
    return Row(
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: genderList[btnValue],
          groupValue: gender,
          onChanged: (value) {
            FocusManager.instance.primaryFocus?.unfocus();
            setState(() {
              gender = value;
            });
          },
        ),
        title.compareTo('Male') == 0
            ? const Icon(
                Icons.male,
                color: Colors.blueAccent,
              )
            : const Icon(
                Icons.female,
                color: Colors.pink,
              ),
      ],
    );
  }

  bool isSameName(String inputName) {
    final petRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets');

    if (mypageStateController.myPageStateType == MyPageStateType.Edit &&
        inputName == petController.selectedPetName) {
      // 편집하는 경우
      return false;
    }

    for (int i = 0; i < petController.petNameList.length; i++) {
      if (petController.petNameList.elementAt(i).compareTo(inputName) == 0) {
        return true;
      }
    }

    return false;
  }

  // 견종 카테고리 선택
  showPickerKategorieArray(BuildContext context) {
    Picker(
      adapter:
          PickerDataAdapter<String>(pickerData: kategorieList, isArray: true),
      hideHeader: true,
      confirmText: '확인',
      confirmTextStyle:
          const TextStyle(color: Color(0xff646CAA), fontFamily: 'bmjua'),
      cancelText: '취소',
      cancelTextStyle:
          const TextStyle(color: Color(0xff646CAA), fontFamily: 'bmjua'),
      title: const Text("견종 카테고리를 골라주세요"),
      onConfirm: (Picker picker, List value) {
        setState(() {
          kategorie = picker.getSelectedValues()[0];
          selectKategorie = true;
          print(kategorie);
        });
      },
    ).showDialog(context);
  }

  // 몸무게 선택
  showPickerWeightArray(BuildContext context) {
    Picker(
      adapter: PickerDataAdapter<String>(pickerData: weightList, isArray: true),
      hideHeader: true,
      confirmText: '확인',
      confirmTextStyle:
          const TextStyle(color: Color(0xff646CAA), fontFamily: 'bmjua'),
      cancelText: '취소',
      cancelTextStyle:
          const TextStyle(color: Color(0xff646CAA), fontFamily: 'bmjua'),
      title: Text("몸무게를 선택하세요"),
      onConfirm: (Picker picker, List value) {
        setState(() {
          weight = int.parse(picker.getSelectedValues()[0]);
          print(weight);
        });
      },
    ).showDialog(context);
  }

  void selectCameraOrGallery(BuildContext context, Size size) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: size.height * 0.15,
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.075,
                  child: ListTile(
                    leading: const Icon(Icons.camera_alt_outlined),
                    title: const Text('촬영하기'),
                    onTap: () {
                      chooseImageInCamera();
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.075,
                  child: ListTile(
                    leading: const Icon(Icons.photo_camera_back),
                    title: const Text('앨범보기'),
                    onTap: () {
                      chooseImageInGallery();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  // 강아지 이미지 선택
  File pickedPetImgFile = File(''); // 강아지 이미지 파일
  final picker = ImagePicker(); // 갤러리에서 가져오기 위한 ImagePicker
  bool pickComp = false; // 사진 선택 완료 여부 확인. 사진 추가 이미지를 선택한 이미지로 변경하기 위함

  chooseImageInGallery() async {
    // 갤러리에서 사진을 가져옴
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile == null) return;

    // 가져온 사진을 원형으로 잘라냄
    var file = await ImageCropper().cropImage(
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 50,
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.circle,
    );

    if (file == null) {
      return;
    }

    //선택 완료
    setState(() => pickedPetImgFile = File(file.path));
    if (file.path == null) retrieveLostData();
    pickComp = true;
    // 수정 모드일 경우, 기존 이미지 파일 제거 필요함. 플래그 변수를 활용하여 업데이트 할 때 파일을 삭제
    if (mypageStateController.myPageStateType == MyPageStateType.Edit) {
      isChangeImg = true;
    }
  }

  chooseImageInCamera() async {
    // 갤러리에서 사진을 가져옴
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile == null) return;

    // 가져온 사진을 원형으로 잘라냄
    var file = await ImageCropper().cropImage(
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 50,
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.circle,
    );

    if (file == null) {
      return;
    }

    //선택 완료
    setState(() => pickedPetImgFile = File(file.path));
    if (file.path == null) retrieveLostData();
    pickComp = true;
    // 수정 모드일 경우, 기존 이미지 파일 제거 필요함. 플래그 변수를 활용하여 업데이트 할 때 파일을 삭제
    if (mypageStateController.myPageStateType == MyPageStateType.Edit) {
      isChangeImg = true;
    }
  }

  // 이미지 파일 저장 실패시 재시도?
  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() => pickedPetImgFile = File(response.file!.path));
    } else {
      print(response.file);
    }
  }

  // 강아지 분류 선택에 따른 권장 시간 반환
  int getRecommendTime(String categorie) {
    int retRecommend = 0;

    switch (categorie) {
      case '논스포팅':
        retRecommend = 60;
        break;
      case '시각 하운드':
        retRecommend = 30;
        break;
      case '후각 하운드':
        retRecommend = 60;
        break;
      case '테리어':
        retRecommend = 40;
        break;
      case '허딩':
        retRecommend = 90;
        break;
      case '토이':
        retRecommend = 40;
        break;
      case '스포팅':
        retRecommend = 90;
        break;
      case '워킹':
        retRecommend = 120;
        break;
    }

    return retRecommend;
  }

  // 강아지 정보 데이터 삭제
  Future<void> _delete() async {
    // Firebase storage 해당 이미지 제거
    FirebaseStorage.instance
        .ref()
        .child(
            '${userController.loginEmail}/dogs/${petController.selectedPetImageFileName}')
        .delete();

    await petsRef.doc(petController.selectedPetID).delete().whenComplete(() {
      petController.selectedPetScrollIndex = 0;
    }).catchError((error) => print(error));
  }

  // 강아지 정보 데이터 수정
  Future<void> _update() async {
    // 편집 모드에서는 이미지 파일을 변경하였을 경우 기존 이미지를 제거하고 새로운 이미지로 갱신
    // 이미지 파일을 변경하지 않았을 경우, Url download 불필요
    if (isChangeImg) {
      // 이미지 파일이 변경되었다면 기존 사진 데이터 제거
      FirebaseStorage.instance
          .ref()
          .child(
              '${userController.loginEmail}/dogs/${petController.selectedPetImageFileName}')
          .delete();

      // 새로 저장할 이미지의 레퍼런스
      Reference petImgRef = FirebaseStorage.instance.ref().child(
          '${userController.loginEmail}/dogs/${Path.basename(pickedPetImgFile.path)}');

      await petImgRef.putFile(pickedPetImgFile).whenComplete(() async {
        await petImgRef.getDownloadURL().then((value) {
          recommend = getRecommendTime(kategorie);

          var map = <String, dynamic>{};
          map["imageUrl"] = value;
          map["imageFileName"] = Path.basename(pickedPetImgFile.path);
          map["name"] = name;
          map["gender"] = gender;
          map["birth"] = birth;
          map["kategorie"] = kategorie;
          map["breed"] = breed;
          map["weight"] = weight;
          map["recommend"] = recommend;

          petsRef
              .doc(petController.selectedPetID)
              .update(map)
              .whenComplete(() => print("변경 완료"))
              .catchError((error) => print(error));
        });
      });
    } else {
      recommend = getRecommendTime(kategorie);

      var map = <String, dynamic>{};
      map["name"] = name;
      map["gender"] = gender;
      map["birth"] = birth;
      map["kategorie"] = kategorie;
      map["breed"] = breed;
      map["weight"] = weight;
      map["recommend"] = recommend;

      petsRef
          .doc(petController.selectedPetID)
          .update(map)
          .whenComplete(() => print("변경 완료"))
          .catchError((error) => print(error));
    }
  }

  // 강아지 정보 데이터 추가
  Future<void> _create() async {
    // 강아지 이미지 파일 저장 경로
    Reference petImgRef = FirebaseStorage.instance.ref().child(
        '${userController.loginEmail}/dogs/${Path.basename(pickedPetImgFile.path)}');

    await petImgRef.putFile(pickedPetImgFile).whenComplete(() async {
      await petImgRef.getDownloadURL().then((value) {
        recommend = getRecommendTime(kategorie);

        //이미지 경로를 db 에 저장
        petsRef
            .add(DogData(
              imageUrl: value,
              imageFileName: Path.basename(pickedPetImgFile.path),
              name: name,
              gender: gender,
              birth: birth,
              kategorie: kategorie,
              breed: breed,
              weight: weight,
              recommend: recommend,
              createdAt: Timestamp.now(),
            ))
            .then((value) => print('강아지 정보 저장 완료'))
            .catchError((error) => print('강아지 정보 저장 오류! $petsRef'));
      });
    });
  }

  // 상태 확인을 위한 boolean 변수
  bool uploadingImg =
      false; // 이미지 업로드 여부 => 사진을 추가가 진행되는 중에 다시 추가 버튼을 누를 경우 동작하지 않도록 함
  bool createData = false; // 데이터 생성 완료 여부
  bool uploadingData = false; // 데이터 업로드 여부 => 버튼을 누르는 순간 다시 동작 못하게 하기 위함.
  bool editingData = false; // 데이터 수정/삭제 여부 => 버튼을 누르는 순간 다시 동작 못하게 하기 위함.
  bool selectBirth = false; // 생일 선택 완료 확인
  bool isChangeImg = false; // 편집 모드에서 기존 사진을 변경 완료했는지 여부
  bool selectKategorie = false; // 카테고리 선택 완료 확인

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

        birth = '$year.${month.padLeft(2, '0')}.${day.padLeft(2, '0')}';
        selectBirth = true;
      });
    }
  }

  // 텍스트 폼을 위한 글로벌 키
  // 이 키는 나중에 폼 내부의 TextFormField 값들을 저장하고 validation 을 진행하는데 사용됨.
  final formkey = GlobalKey<FormState>();

  // 편집 모드 일 경우 기존 데이터를 텍스트 폼에 띄우기 위함.
  TextEditingController _nameController = TextEditingController();
  TextEditingController _breedController = TextEditingController();

  // Widget
  // 정보 화면 타이틀 위젯
  Row infoTitleBox(double cardHeight, String title) {
    return Row(
      children: [
        Text(
          '$title  ',
          style: TextStyle(
            color: const Color(0xff646CAA),
            fontSize: cardHeight * 0.035,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    petsRef = FirebaseFirestore.instance.collection('Users/${userController.loginEmail}/Pets')
        .withConverter(fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!),
        toFirestore: (dogData, _) => dogData.toJson());

    // 편집 모드인 경우 기존 정보를 띄우기 위함
    if (mypageStateController.myPageStateType == MyPageStateType.Edit) {
      pickComp = true; // 사진이 골라져있음

      // 선택한 강아지로 이름 초기화
      name = petController.selectedPetName;
      _nameController =
          TextEditingController(text: petController.selectedPetName);
      // 선택한 강아지로 성별 초기화
      gender = petController.selectedPetGender;
      // 선택한 강아지로 생일 초기화
      birth = petController.selectedPetBirth;
      selectBirth = true;
      // 선택한 강아지로 카테고리 초기화
      kategorie = petController.selectedPetKategorie;
      // 선택한 강아지로 견종 초기화
      breed = petController.selectedPetBreed;
      _breedController =
          TextEditingController(text: petController.selectedPetBreed);
      // 선택한 강아지로 무게 초기화
      weight = petController.selectedPetWeight;
    }

    for (int i = 1; i <= 200; i++) {
      weightList[0].add(i.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // 디바이스 사이즈 크기 정의
    final Size size = MediaQuery.of(context).size;

    // 반려견 정보 표시 카드의 너비, 높이 정의
    final double petInfoWidth = size.width * 0.8;
    final double petInfoHeight = size.height * 0.7;

    TextStyle guideTextStyle = TextStyle(
        color: const Color(0xff504E5B), fontSize: petInfoHeight * 0.027);

    return GestureDetector(
      onTap: () {
        // 폼 이외의 위치를 탭하면 키보드 해제
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            mypageStateController.myPageStateType == MyPageStateType.Create
                ? '추가하기'
                : '편집하기',
            style: const TextStyle(
              color: Colors.black,
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
                      backgroundColor: const Color(0xff646CAA),
                      radius: size.width * 0.2,
                      child: pickComp
                          ? ClipOval(
                              child: mypageStateController.myPageStateType ==
                                      MyPageStateType.Create
                                  ? Image(image: FileImage(pickedPetImgFile))
                                  : !isChangeImg
                                      ? Image(
                                          image: CachedNetworkImageProvider(
                                              petController
                                                  .selectedPetImageUrl))
                                      : Image(
                                          image: FileImage(pickedPetImgFile)))
                          : Icon(Icons.add,
                              size: size.width * 0.2, color: Colors.white),
                    ),
                  ],
                ),
                onTap: () {
                  // 키보드 해제
                  FocusManager.instance.primaryFocus?.unfocus();
                  // 연속 클릭 방지
                  !uploadingImg ? selectCameraOrGallery(context, size) : null;
                },
              ),
              SizedBox(height: size.height * 0.01),
              // 강아지 정보
              Center(
                child: Container(
                  height: petInfoHeight,
                  width: petInfoWidth,
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
                      padding: EdgeInsets.fromLTRB(size.width * 0.05,
                          size.width * 0.05, size.width * 0.05, 0),
                      child: Form(
                        key: formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 이름
                            infoTitleBox(petInfoHeight, '이름'),
                            SizedBox(
                              height: petInfoHeight * 0.07,
                              child: TextFormField(
                                onSaved: (value) {
                                  name = value!;
                                },
                                onChanged: (value) {
                                  name = value;
                                },
                                style: guideTextStyle,
                                decoration: const InputDecoration(
                                  hintText: ' 이름을 입력하세요!',
                                ),
                                controller: _nameController,
                              ),
                            ),
                            SizedBox(height: petInfoHeight * 0.03),
                            // 성별
                            infoTitleBox(petInfoHeight, '성별'),
                            SizedBox(height: petInfoHeight * 0.01),
                            SizedBox(
                              height: petInfoHeight * 0.06,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  addRadioButton(0, 'Male'),
                                  addRadioButton(1, 'Female'),
                                ],
                              ),
                            ),
                            Divider(
                                color: const Color(0xff504E5B),
                                height: petInfoHeight * 0.03,
                                thickness: 0.5),
                            // 생일
                            SizedBox(height: petInfoHeight * 0.02),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                infoTitleBox(petInfoHeight, '생일'),
                                SizedBox(
                                  height: petInfoHeight * 0.07,
                                  child: TextButton(
                                    onPressed: () async {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      await _selectDate(context);
                                    },
                                    child: Text(birth, style: guideTextStyle),
                                  ),
                                ),
                                Divider(
                                    color: const Color(0xff504E5B),
                                    height: petInfoHeight * 0.01,
                                    thickness: 0.5),
                              ],
                            ),
                            SizedBox(height: petInfoHeight * 0.02),
                            //카테고리
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    infoTitleBox(petInfoHeight, '분류'),
                                    InkWell(
                                      onTap: () {
                                        FlutterDialog(context);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor:
                                            const Color(0xff504E5B),
                                        radius: petInfoHeight * 0.015,
                                        child: Icon(
                                          Icons.question_mark,
                                          size: petInfoHeight * 0.025,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: petInfoHeight * 0.06,
                                  child: TextButton(
                                    onPressed: () async {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      showPickerKategorieArray(context);
                                    },
                                    child:
                                        Text(kategorie, style: guideTextStyle),
                                  ),
                                ),
                                Divider(
                                    color: const Color(0xff504E5B),
                                    height: petInfoHeight * 0.01,
                                    thickness: 0.5),
                              ],
                            ),
                            SizedBox(height: petInfoHeight * 0.02),
                            // 견종
                            infoTitleBox(petInfoHeight, '견종'),
                            SizedBox(
                              height: petInfoHeight * 0.07,
                              child: TextFormField(
                                onSaved: (value) {
                                  breed = value!;
                                },
                                onChanged: (value) {
                                  breed = value;
                                },
                                decoration: const InputDecoration(
                                  hintText: ' 견종을 입력하세요!',
                                ),
                                controller: _breedController,
                                style: guideTextStyle,
                              ),
                            ),
                            SizedBox(height: petInfoHeight * 0.02),
                            // 몸무게
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                infoTitleBox(petInfoHeight, '무게'),
                                SizedBox(
                                  height: petInfoHeight * 0.07,
                                  child: TextButton(
                                    onPressed: () async {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      showPickerWeightArray(context);
                                    },
                                    child: Text(
                                        weight == 0
                                            ? '몸무게를 입력하세요.'
                                            : '${weight}kg',
                                        style: TextStyle(
                                            color: const Color(0xff504E5B),
                                            fontSize: petInfoHeight * 0.027)),
                                  ),
                                ),
                                Divider(
                                    color: const Color(0xff504E5B),
                                    height: petInfoHeight * 0.01,
                                    thickness: 0.5),
                              ],
                            ),
                            SizedBox(height: petInfoHeight * 0.04),

                            // 버튼
                            mypageStateController.myPageStateType ==
                                    MyPageStateType.Create
                                ? Center(
                                    child: !uploadingData
                                        ? ElevatedButton(
                                            onPressed: !uploadingData
                                                ? () async {
                                                    // 키보드 해제
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();

                                                    // 버튼 중복 클릭 시 재호출 방지
                                                    if (uploadingData) return;

                                                    setState(() {
                                                      uploadingData = true;
                                                    });

                                                    // 사진을 등록 하지 않을 경우 알림
                                                    if (!pickComp) {
                                                      MyPageSnackBar()
                                                          .notfoundDogData(
                                                              context,
                                                              SnackBarErrorType
                                                                  .ImageNotExist);
                                                      uploadingData = false;
                                                      return;
                                                    }

                                                    // 이름을 등록 하지 않을 경우 알림
                                                    if (name.isEmpty) {
                                                      MyPageSnackBar()
                                                          .notfoundDogData(
                                                              context,
                                                              SnackBarErrorType
                                                                  .NameNotExist);
                                                      uploadingData = false;
                                                      return;
                                                    }

                                                    // 이름이 10글자를 초과할 경우 알림
                                                    if (name.length > 10) {
                                                      MyPageSnackBar()
                                                          .notfoundDogData(
                                                              context,
                                                              SnackBarErrorType
                                                                  .NameOverflow);
                                                      uploadingData = false;
                                                      return;
                                                    }

                                                    // 이름 중복 검사
                                                    if (isSameName(name)) {
                                                      MyPageSnackBar()
                                                          .notfoundDogData(
                                                              context,
                                                              SnackBarErrorType
                                                                  .NameAlreadyExist);
                                                      uploadingData = false;
                                                      return;
                                                    }

                                                    // 생일을 선택하지 않은 경우 알림
                                                    if (!selectBirth) {
                                                      MyPageSnackBar()
                                                          .notfoundDogData(
                                                              context,
                                                              SnackBarErrorType
                                                                  .BirthNotExist);
                                                      uploadingData = false;
                                                      return;
                                                    }

                                                    // 견종 그룹을 입력하지 않은 경우 알림
                                                    if (!selectKategorie) {
                                                      MyPageSnackBar()
                                                          .notfoundDogData(
                                                              context,
                                                              SnackBarErrorType
                                                                  .KategorieNotExist);
                                                      uploadingData = false;
                                                      return;
                                                    }

                                                    // 견종을 입력하지 않은 경우 알림
                                                    if (breed.isEmpty) {
                                                      MyPageSnackBar()
                                                          .notfoundDogData(
                                                              context,
                                                              SnackBarErrorType
                                                                  .BreedNotExist);
                                                      uploadingData = false;
                                                      return;
                                                    }

                                                    // 견종이 20글자를 초과할 경우 알림
                                                    if (breed.length > 20) {
                                                      MyPageSnackBar()
                                                          .notfoundDogData(
                                                              context,
                                                              SnackBarErrorType
                                                                  .BreedOverflow);
                                                      uploadingData = false;
                                                      return;
                                                    }

                                                    // 몸무게 미 입력은 미입력으로 표기

                                                    await _create()
                                                        .whenComplete(() {
                                                      if (Navigator.canPop(
                                                          context)) {
                                                        Navigator.pop(context);
                                                      }
                                                    });

                                                    setState(() {
                                                      createData = true;
                                                      uploadingData = false;
                                                    });
                                                  }
                                                : null,
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      const Color(0xff646CAA)),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                            ),
                                            child: Text('등록하기'),
                                          )
                                        : const CircularProgressIndicator(),
                                  )
                                : !editingData
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            onPressed: !editingData
                                                ? () async {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();

                                                    // 버튼 중복 클릭 시 재호출 방지
                                                    if (editingData) return;

                                                    setState(() {
                                                      editingData = true;
                                                    });

                                                    // 사진을 등록 하지 않을 경우 알림
                                                    if (!pickComp) {
                                                      MyPageSnackBar()
                                                          .notfoundDogData(
                                                              context,
                                                              SnackBarErrorType
                                                                  .ImageNotExist);
                                                      editingData = false;
                                                      return;
                                                    }

                                                    // 이름을 등록 하지 않을 경우 알림
                                                    if (name.isEmpty) {
                                                      MyPageSnackBar()
                                                          .notfoundDogData(
                                                              context,
                                                              SnackBarErrorType
                                                                  .NameNotExist);
                                                      editingData = false;
                                                      editingData = false;
                                                      return;
                                                    }

                                                    // 이름이 10글자를 초과할 경우 알림
                                                    if (name.length > 10) {
                                                      MyPageSnackBar()
                                                          .notfoundDogData(
                                                              context,
                                                              SnackBarErrorType
                                                                  .NameOverflow);
                                                      editingData = false;
                                                      return;
                                                    }

                                                    // 이름 중복 검사
                                                    if (isSameName(name)) {
                                                      MyPageSnackBar()
                                                          .notfoundDogData(
                                                              context,
                                                              SnackBarErrorType
                                                                  .NameAlreadyExist);
                                                      editingData = false;
                                                      return;
                                                    }

                                                    // 생일을 선택하지 않은 경우
                                                    if (!selectBirth) {
                                                      MyPageSnackBar()
                                                          .notfoundDogData(
                                                              context,
                                                              SnackBarErrorType
                                                                  .BirthNotExist);
                                                      editingData = false;
                                                      return;
                                                    }

                                                    // 견종을 입력하지 않은 경우
                                                    if (breed.isEmpty) {
                                                      MyPageSnackBar()
                                                          .notfoundDogData(
                                                              context,
                                                              SnackBarErrorType
                                                                  .BreedNotExist);
                                                      editingData = false;
                                                      return;
                                                    }

                                                    // 견종이 20글자를 초과할 경우 알림
                                                    if (breed.length > 20) {
                                                      MyPageSnackBar()
                                                          .notfoundDogData(
                                                              context,
                                                              SnackBarErrorType
                                                                  .BreedOverflow);
                                                      editingData = false;
                                                      return;
                                                    }

                                                    await _update()
                                                        .whenComplete(() {
                                                          inputController.selectedValue = name;
                                                          for(int idx = 0; idx < inputController.valueList.length; idx++) {
                                                            if(inputController.valueList[idx].compareTo(petController.selectedPetName) == 0){
                                                              inputController.valueList[idx] = name;
                                                              break;
                                                            }
                                                          };

                                                      if (Navigator.canPop(
                                                          context)) {
                                                        Navigator.pop(context);
                                                      }

                                                      setState(() {
                                                        editingData = false;
                                                      });
                                                    });
                                                  }
                                                : null,
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      const Color(0xff646CAA)),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                            ),
                                            child: Text('변경하기'),
                                          ),
                                          ElevatedButton(
                                            onPressed: !editingData
                                                ? () async {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();

                                                    // 버튼 중복 클릭 시 재호출 방지
                                                    if (editingData) return;

                                                    setState(() {
                                                      editingData = true;
                                                    });

                                                    petController
                                                        .selectedPetScrollIndex = 0;
                                                    homeSliderController
                                                        .sliderIdx = 0;

                                                    await _delete()
                                                        .whenComplete(() {
                                                          for(int idx = 0; idx < inputController.valueList.length; idx++) {
                                                            if(inputController.valueList[idx].compareTo(petController.selectedPetName) == 0){
                                                              inputController.valueList.removeAt(idx);
                                                              inputController.selectedValue = '';
                                                              break;
                                                            }
                                                          };
                                                      if (Navigator.canPop(
                                                          context)) {
                                                        Navigator.pop(context);
                                                      }

                                                      setState(() {
                                                        editingData = false;
                                                      });
                                                    });
                                                  }
                                                : null,
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      const Color(0xff646CAA)),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                            ),
                                            child: Text('삭제하기'),
                                          ),
                                        ],
                                      )
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              )
            ],
          ),
        ),
      ),
    );
  }
}
