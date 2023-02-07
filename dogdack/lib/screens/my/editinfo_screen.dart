import 'package:flutter/material.dart';

// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_picker/picker.dart';

// GetX
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'controller/mypage_controller.dart';

// Model
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
  // Firebase : 반려견 테이블 참조 값
  final petsRef = FirebaseFirestore.instance.collection('Users/${FirebaseAuth.instance.currentUser!.email.toString()}/Pets')
      .withConverter(fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!), toFirestore: (dogData, _) => dogData.toJson());

  // GetX
  final petController = Get.put(PetController());
  final mypageStateController = Get.put(MyPageStateController());

  // 강아지 정보 : (GetX 강아지 정보 관련 변수는 조회 페이지에서 선택한 정보이기 때문에 다르게 관리함)
  final kategorieList = [['논스포팅', '시각 하운드', '후각 하운드', '테리어', '허딩', '토이', '스포팅', '워킹']]; // 견종 카테고리 리스트
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
            ? Icon(Icons.male, color: Colors.blueAccent,)
            : Icon(Icons.female, color: Colors.pink,),
      ],
    );
  }

  // 견종 카테고리 선택
  showPickerKategorieArray(BuildContext context) {
    new Picker(
        adapter: PickerDataAdapter<String>(
          pickerData: kategorieList,
          isArray: true),
        hideHeader: true,
        confirmText: '확인',
        confirmTextStyle: TextStyle(color: Color(0xff646CAA), fontFamily: 'bmjua'),
        cancelText: '취소',

        cancelTextStyle: TextStyle(color: Color(0xff646CAA), fontFamily: 'bmjua'),
        title: new Text("견종 카테고리를 골라주세요"),
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
    new Picker(
      adapter: PickerDataAdapter<String>(
          pickerData: weightList,
          isArray: true),
      hideHeader: true,
      confirmText: '확인',
      confirmTextStyle: TextStyle(color: Color(0xff646CAA), fontFamily: 'bmjua'),
      cancelText: '취소',

      cancelTextStyle: TextStyle(color: Color(0xff646CAA), fontFamily: 'bmjua'),
      title: new Text("몸무게를 선택하세요"),
      onConfirm: (Picker picker, List value) {
        setState(() {
          weight = int.parse(picker.getSelectedValues()[0]);
          print(weight);
        });
      },
    ).showDialog(context);
  }

  // 강아지 이미지 선택
  File pickedPetImgFile = File(''); // 강아지 이미지 파일
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
    setState(() => pickedPetImgFile = File(file.path));
    if (file.path == null) retrieveLostData();
    if (pickedPetImgFile != null) {
      pickComp = true;
      // 수정 모드일 경우, 기존 이미지 파일 제거 필요함. 플래그 변수를 활용하여 업데이트 할 때 파일을 삭제
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
      setState(() => pickedPetImgFile = File(response.file!.path));
    } else {
      print(response.file);
    }
  }

  // 강아지 정보 데이터 삭제
  Future<void> _delete([DocumentSnapshot? documentSnapshot]) async {
    // Firebase storage 해당 이미지 제거
    FirebaseStorage.instance.ref().child('${FirebaseAuth.instance.currentUser!.email.toString()}/dogs/${petController.selectedPetImageFileName}').delete();

    await petsRef
        .doc(petController.selectedPetID)
        .delete()
        .whenComplete(() {petController.selectedPetScrollIndex = 0;})
        .catchError((error) => print(error));
  }

  // 강아지 정보 데이터 수정
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    // 편집 모드에서는 이미지 파일을 변경하였을 경우 기존 이미지를 제거하고 새로운 이미지로 갱신
    // 이미지 파일을 변경하지 않았을 경우, Url download 불필요
    if(isChangeImg) {
      // 이미지 파일이 변경되었다면 기존 사진 데이터 제거
      FirebaseStorage.instance.ref().child('${FirebaseAuth.instance.currentUser!.email.toString()}/dogs/${petController.selectedPetImageFileName}').delete();

      // 새로 저장할 이미지의 레퍼런스
      Reference petImgRef = FirebaseStorage.instance.ref().child(
          '${FirebaseAuth.instance.currentUser!.email.toString()}/dogs/${Path.basename(pickedPetImgFile!.path)}');

      await petImgRef!.putFile(pickedPetImgFile!).whenComplete(() async {
        await petImgRef!.getDownloadURL().then((value) {
          switch(kategorie) {
            case '논스포팅' :
              recommend = 60;
              break;
            case '시각 하운드' :
              recommend = 30;
              break;
            case '후각 하운드' :
              recommend = 60;
              break;
            case '테리어' :
              recommend = 40;
              break;
            case '허딩' :
              recommend = 90;
              break;
            case '토이' :
              recommend = 40;
              break;
            case '스포팅' :
              recommend = 90;
              break;
            case '워킹' :
              recommend = 120;
              break;
          }

          var map = Map<String, dynamic>();
          map["imageUrl"] = value;
          map["imageFileName"] = Path.basename(pickedPetImgFile!.path);
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
      switch(kategorie) {
        case '논스포팅' :
          recommend = 60;
          break;
        case '시각 하운드' :
          recommend = 30;
          break;
        case '후각 하운드' :
          recommend = 60;
          break;
        case '테리어' :
          recommend = 40;
          break;
        case '허딩' :
          recommend = 90;
          break;
        case '토이' :
          recommend = 40;
          break;
        case '스포팅' :
          recommend = 90;
          break;
        case '워킹' :
          recommend = 120;
          break;
      }

      var map = Map<String, dynamic>();
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
  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    // 강아지 이미지 파일 저장 경로
    Reference petImgRef = FirebaseStorage.instance.ref().child(
        '${FirebaseAuth.instance.currentUser!.email.toString()}/dogs/${Path.basename(pickedPetImgFile!.path)}');

    await petImgRef!.putFile(pickedPetImgFile!).whenComplete(() async {
      await petImgRef!.getDownloadURL().then((value) {
        switch(kategorie) {
          case '논스포팅' :
            recommend = 60;
            break;
          case '시각 하운드' :
            recommend = 30;
            break;
          case '후각 하운드' :
            recommend = 60;
            break;
          case '테리어' :
            recommend = 40;
            break;
          case '허딩' :
            recommend = 90;
            break;
          case '토이' :
            recommend = 40;
            break;
          case '스포팅' :
            recommend = 90;
            break;
          case '워킹' :
            recommend = 120;
            break;
        }

        //이미지 경로를 db 에 저장
        petsRef.add(DogData(
          imageUrl: value,
          imageFileName: Path.basename(pickedPetImgFile!.path),
          name: name,
          gender: gender,
          birth: birth,
          kategorie: kategorie,
          breed: breed,
          weight: weight,
          recommend: recommend,
          createdAt: Timestamp.now(),
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

        birth = '${year}.${month}.${day}';
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
          '${title}  ',
          style: TextStyle(
            color: Color(0xff646CAA),
            fontSize: cardHeight * 0.035,
          ),
        ),
        CircleAvatar(
          child: Icon(
            Icons.edit,
            size: cardHeight * 0.025,
            color: Colors.white,
          ),
          backgroundColor: Color(0xff504E5B),
          radius: cardHeight * 0.015,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    // 편집 모드인 경우 기존 정보를 띄우기 위함
    if (mypageStateController.myPageStateType == MyPageStateType.Edit) {
      pickComp = true; // 사진이 골라져있음

      _nameController = TextEditingController(text: petController.selectedPetName); // 이름
      gender = petController.selectedPetGender; // 성별
      birth = petController.selectedPetBirth; // 생일
      kategorie = petController.selectedPetKategorie; // 카테고리
      _breedController = TextEditingController(text: petController.selectedPetBreed); // 견종
      weight = petController.selectedPetWeight; // 몸무게
    }

    for(int i = 1; i <= 200; i++)
      weightList[0].add(i.toString());
  }

  @override
  Widget build(BuildContext context) {
    // 디바이스 사이즈 크기 정의
    final Size size = MediaQuery.of(context).size;

    // 반려견 정보 표시 카드의 너비, 높이 정의
    final double petInfoWidth = size.width * 0.8;
    final double petInfoHeight = size.height * 0.7;

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
                      backgroundColor: Color(0xff646CAA),
                      radius: size.width * 0.2,
                      child: pickComp
                          ? ClipOval(child: mypageStateController.myPageStateType == MyPageStateType.Create
                            ? Image(image: FileImage(pickedPetImgFile))
                            : !isChangeImg
                              ? Image.network(petController.selectedPetImageUrl)
                              : Image(image: FileImage(pickedPetImgFile)))
                          : Icon(Icons.add, size: size.width * 0.2, color: Colors.white),
                    ),
                  ],
                ),
                onTap: () {
                  // 키보드 해제
                  FocusManager.instance.primaryFocus?.unfocus();
                  // 연속 클릭 방지
                  !uploadingImg ? chooseImage() : null;
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
                      padding: EdgeInsets.fromLTRB(size.width * 0.05, size.width * 0.05, size.width * 0.05, 0),
                      child: Form(
                        key: this.formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 이름
                            infoTitleBox(petInfoHeight, '이름'),
                            Container(
                              height: petInfoHeight * 0.07,
                              child: TextFormField(
                                onSaved: (value) {
                                  name = value!;
                                },
                                onChanged: (value) {
                                  name = value!;
                                },
                                style: TextStyle(color: Color(0xff504E5B)),
                                decoration: InputDecoration(
                                  hintText: '이름을 입력하세요!',
                                ),
                                controller: _nameController,
                              ),
                            ),
                            SizedBox(height: petInfoHeight * 0.03),
                            // 성별
                            infoTitleBox(petInfoHeight, '성별'),
                            SizedBox(height: petInfoHeight * 0.01),
                            Container(
                              height: petInfoHeight * 0.06,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  addRadioButton(0, 'Male'),
                                  addRadioButton(1, 'Female'),
                                ],
                              ),
                            ),
                            Divider(color: Color(0xff504E5B), height: petInfoHeight * 0.03, thickness: 0.5),
                            // 생일
                            SizedBox(height: petInfoHeight * 0.02),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                infoTitleBox(petInfoHeight, '생일'),
                                Container(
                                  height: petInfoHeight * 0.07,
                                  child: TextButton(
                                    onPressed: () async {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      await _selectDate(context);
                                    },
                                    child: Text(birth, style: TextStyle(color: Color(0xff504E5B), fontSize: petInfoHeight * 0.027)),
                                  ),
                                ),
                                Divider(color: Color(0xff504E5B), height: petInfoHeight * 0.01, thickness: 0.5),
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
                                    SizedBox(width: petInfoWidth * 0.02,),
                                    InkWell(
                                      onTap: () {
                                        FlutterDialog(context);
                                      },
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.question_mark,
                                          size: petInfoHeight * 0.025,
                                          color: Colors.white,
                                        ),
                                        backgroundColor: Color(0xff504E5B),
                                        radius: petInfoHeight * 0.015,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: petInfoHeight * 0.06,
                                  child: TextButton(
                                    onPressed: () async {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      showPickerKategorieArray(context);
                                    },
                                    child: Text(kategorie, style: TextStyle(color: Color(0xff504E5B), fontSize: petInfoHeight * 0.027)),
                                  ),
                                ),
                                Divider(color: Color(0xff504E5B), height: petInfoHeight * 0.01, thickness: 0.5),
                              ],
                            ),
                            SizedBox(height: petInfoHeight * 0.02),
                            // 견종
                            infoTitleBox(petInfoHeight, '견종'),
                            Container(
                              height: petInfoHeight * 0.07,
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
                            SizedBox(height: petInfoHeight * 0.02),
                            // 몸무게
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                infoTitleBox(petInfoHeight, '무게'),
                                Container(
                                  height: petInfoHeight * 0.07,
                                  child: TextButton(
                                    onPressed: () async {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      showPickerWeightArray(context);
                                    },
                                    child: Text(weight == 0? '몸무게를 입력하세요.' : '${weight}kg', style: TextStyle(color: Color(0xff504E5B), fontSize: petInfoHeight * 0.027)),
                                  ),
                                ),
                                Divider(color: Color(0xff504E5B), height: petInfoHeight * 0.01, thickness: 0.5),
                              ],
                            ),
                            SizedBox(height: petInfoHeight * 0.04),

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

                                    // 이름이 10글자를 초과할 경우 알림
                                    if(name.length > 10) {
                                      MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.NameOverflow);
                                      uploadingData = false;
                                      return;
                                    }

                                    // 생일을 선택하지 않은 경우 알림
                                    if(!selectBirth) {
                                      MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.BirthNotExist);
                                      uploadingData = false;
                                      return;
                                    }

                                    // 견종 그룹을 입력하지 않은 경우 알림
                                    if(!selectKategorie) {
                                      MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.KategorieNotExist);
                                      uploadingData = false;
                                      return;
                                    }

                                    // 견종을 입력하지 않은 경우 알림
                                    if(breed.length == 0) {
                                      MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.BreedNotExist);
                                      uploadingData = false;
                                      return;
                                    }

                                    // 견종이 20글자를 초과할 경우 알림
                                    if(breed.length > 20) {
                                      MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.BreedOverflow);
                                      uploadingData = false;
                                      return;
                                    }

                                    // 몸무게 미 입력은 미입력으로 표기

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
                                  child: Text('등록하기'),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Color(0xff646CAA)),
                                    foregroundColor: MaterialStateProperty.all(Colors.white),
                                  ),)
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
                                                if (!selectBirth) {
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

                                                // 견종이 20글자를 초과할 경우 알림
                                                if(breed.length > 20) {
                                                  MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.BreedOverflow);
                                                  uploadingData = false;
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
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(Color(0xff646CAA)),
                                            foregroundColor: MaterialStateProperty.all(Colors.white),
                                          ),
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

                                                  petController.selectedPetScrollIndex = 0;

                                                  setState(() {
                                                    editingData = false;
                                                  });
                                                });
                                              }
                                              : null,
                                          child: Text('삭제하기'),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(Color(0xff646CAA)),
                                            foregroundColor: MaterialStateProperty.all(Colors.white),
                                          ),
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
