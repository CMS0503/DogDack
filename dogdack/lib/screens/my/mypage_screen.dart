// Widgets
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dogdack/models/user_data.dart';
import 'package:dogdack/screens/my/widgets/mypage_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:auto_size_text/auto_size_text.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// GetX
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

// Controller
import '../../commons/logo_widget.dart';
import '../../controllers/main_controll.dart';
import '../../controllers/mypage_controller.dart';

// Models
import 'package:dogdack/models/dog_data.dart';

// Screen
import 'editinfo_screen.dart';

class MyPage extends StatefulWidget {
  MyPage({super.key});

  final inputController = TextEditingController();

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  // Firebase : 반려견 테이블 참조 값
  final petsRef = FirebaseFirestore.instance.collection('Users/${FirebaseAuth.instance.currentUser!.email.toString()}/Pets')
      .withConverter(fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!), toFirestore: (dogData, _) => dogData.toJson());

  // Firebase : 유저 전화 번호 저장을 위한 참조 값
  final userRef = FirebaseFirestore.instance.collection('Users/${FirebaseAuth.instance.currentUser!.email.toString()}/UserInfo')
      .withConverter(fromFirestore: (snapshot, _) => UserData.fromJson(snapshot.data()!), toFirestore: (userData, _) => userData.toJson());

  // GetX
  final petController = Get.put(PetController()); // 슬라이더에서 선택된 반려견 정보를 위젯간 공유
  final mypageStateController = Get.put(MyPageStateController()); // 현재 mypage 의 상태 표시
  final userDataController = Get.put(UserDataController());
  final mainController = Get.put(MainController());

  // Widget
  // 정보 화면 타이틀 위젯
  Container infoTitleBox(double cardWith, double cardHeight, String title) {
    return Container(
      width: cardWith * 0.48,
      height: cardHeight * 0.08,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff644CAA), width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Color(0xff644CAA),
            fontSize: cardWith * 0.06,
          ),
        ),
      ),
    );
  }

  // 총 산책 시간 계산
  Stream<num> getTotalWalkMin() async* {
    num totalWalkMin = 0; // 총 산책 시간
    CollectionReference petRef = FirebaseFirestore.instance
        .collection('Users/${FirebaseAuth.instance.currentUser!.email.toString()}/Pets');
    QuerySnapshot _docInPets = await petRef.get();
    for (int i = 0; i < _docInPets.docs.length; i++) {
      String _docInPetsID = _docInPets.docs[i].id; // Pets Collection 아래 문서 이름 (반려견 이름)
      CollectionReference walkRef = petsRef.doc('${_docInPetsID}').collection('Walk');
      QuerySnapshot _docInWalk = await walkRef.get();
      for (int j = 0; j < _docInWalk.docs.length; j++) {
        totalWalkMin += _docInWalk.docs[j]['totalTimeMin'];
      }
    }

    yield totalWalkMin;
  }

  // 총 산책 횟수 계산
  Stream<num> getTotalWalkCnt() async* {
    num totalWalkCnt = 0; // 총 산책 횟수
    CollectionReference petRef = FirebaseFirestore.instance.collection(
        'Users/${FirebaseAuth.instance.currentUser!.email.toString()}/Pets');
    QuerySnapshot _docInPets = await petRef.get();
    for (int i = 0; i < _docInPets.docs.length; i++) {
      String _docInPetsID = _docInPets.docs[i]
          .id; // Pets Collection 아래 문서 이름 (반려견 이름)
      CollectionReference walkRef = petsRef.doc('${_docInPetsID}').collection(
          'Walk');
      QuerySnapshot _docInWalk = await walkRef.get();
      totalWalkCnt += _docInWalk.docs.length;
    }

    yield totalWalkCnt;
  }

  @override
  void initState() {
    super.initState();
    // 총 산책 시간과 총 산책 횟수 계산
    getTotalWalkMin();
    getTotalWalkCnt();
  }

  @override
  Widget build(BuildContext context) {
    // 디바이스 사이즈 크기 정의
    final Size size = MediaQuery.of(context).size;

    // 반려견 정보 표시 카드의 너비, 높이 정의
    final double petInfoWidth = size.width * 0.8;
    final double petInfoHeight = size.height * 0.45;

    // 스크린 상태 갱신 : 정보 조회 화면
    mypageStateController.myPageStateType = MyPageStateType.View;

    //총 산책 시간, 총 산책 횟수 계산
    getTotalWalkMin();
    getTotalWalkCnt();

    return GestureDetector(
      onTap: () {
        // 포커스를 벗어나면 키보드를 해제함
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.12),
          child: const LogoWidget(),
        ),
        floatingActionButton: Container(
          padding: EdgeInsets.fromLTRB(0, 0, size.width * 0.05, size.width * 0.05),
          child: FloatingActionButton(
            heroTag: 'petAdd',
            onPressed: () {
              // 생성 모드
              mypageStateController.myPageStateType = MyPageStateType.Create;
              // 반려견 정보 추가 페이지로 이동
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditDogInfoPage()));
            },
            child: Icon(Icons.add),
            backgroundColor: Color(0xff644CAA),
          ),
        ),
        // 키보드 등장 시 화면 오버플로우가 발생하지 않도록 함.
        body: SingleChildScrollView(
          child: Padding(
            // body 내 모든 위젯의 padding 설정
            padding: EdgeInsets.fromLTRB(0, size.height * 0.03, 0, 0),
            child: Column(
              children: [
                // 사용자 정보
                StreamBuilder(
                  stream: petsRef.snapshots(),
                  builder: (petContext, petSnapshot) {
                    //데이터를 불러오지 못했으면 로딩
                    if (!petSnapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    //사용자 정보
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            // 사용자 계정 이미지
                            StreamBuilder(
                              stream: userRef.snapshots(),
                              builder: (userContext, userSnapshot) {
                                if(!userSnapshot.hasData)
                                  return CircularProgressIndicator();

                                String phNum = '아직 번호가 등록 되어 있지 않습니다.';
                                if(userSnapshot.data!.docs.length != 0) {
                                  phNum = userSnapshot.data!.docs[0].get('phoneNumber');
                                }

                                return InkWell(
                                  onTap: () {
                                    showTextInputDialog(
                                      context: context,
                                      title: '전화 번호',
                                      message: '현재 전화 번호 \n\n ${phNum}',
                                      textFields: [
                                        DialogTextField(
                                          keyboardType: TextInputType.number,
                                          hintText: '전화 번호를 입력하세요',
                                        )
                                      ],
                                    ).then((value) {
                                      if(value == null)
                                        return;

                                      var map = Map<String, dynamic>();
                                      map["phoneNumber"] = value.elementAt(0).toString();

                                      if(value.elementAt(0).toString().length == 0) {
                                        MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.PhoneNumberNotExist);
                                        return;
                                      }

                                      if(userSnapshot.data!.docs.length == 0) {
                                        userRef.doc('number').set(UserData(phoneNumber: value.elementAt(0).toString())).then((value) => print('전화번호 저장 완료'))
                                            .catchError((error) => print('전화번호 저장 오류! ${error}'));
                                      } else {
                                        userRef.doc('number').update(map)
                                            .whenComplete(() => print("변경 완료")).catchError((error) => print('전화번호 저장 오류! ${error}'));
                                      }
                                    });
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: size.width * 0.10,
                                    backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL.toString()),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xff504E5B),
                                        radius: petInfoWidth * 0.05,
                                        child: Icon(
                                          Icons.phone,
                                          size: petInfoWidth * 0.05,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            // 사용자 닉네임
                            Container(
                              width: size.width * 0.2,
                              child: Text(
                                FirebaseAuth.instance.currentUser!.displayName.toString(),
                                style: TextStyle(
                                  fontSize: size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        // 산책 횟수
                        Column(
                          children: [
                            GetBuilder<MainController>(
                              builder: (_) {
                                getTotalWalkCnt();
                                return StreamBuilder(
                                    stream: getTotalWalkCnt(),
                                    builder: (context, snapshot) {
                                      if(!snapshot.hasData) {
                                        return Text('0');
                                      }

                                      return Text(snapshot.data.toString());
                                    }
                                );
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            Text('산책 카운트'),
                          ],
                        ),
                        // 산책 시간
                        Column(
                          children: [
                            GetBuilder<MainController>(
                              builder: (_) {
                                getTotalWalkMin();
                                return StreamBuilder(
                                    stream: getTotalWalkMin(),
                                    builder: (context, snapshot) {
                                      if(!snapshot.hasData) {
                                        return Text('0');
                                      }

                                      return Text(snapshot.data.toString());
                                    }
                                );
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            Text('산책 시간'),
                          ],
                        ),
                        // 반려견 수
                        Column(
                          children: [
                            Text(petSnapshot.data!.docs.length.toString()),
                            SizedBox(height: size.height * 0.02),
                            Text('댕댕이'),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                // 반려견 정보
                StreamBuilder(
                  stream: petsRef.orderBy('createdAt').snapshots(),
                  builder: (context, snapshot) {
                    // 데이터를 아직 불러오지 못했으면 로딩
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    // 불러온 데이터가 없을 경우 등록 안내
                    if (snapshot.data!.docs.length == 0) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(0, size.height * 0.3, 0, 0),
                        child: Text('댕댕이를 등록해주세요!'),
                      );
                    }

                    // 여기서 부터는 등록된 반려견이 1마리 이상 존재함.

                    // 마지막으로 저장된 스크롤 인덱스에 맞춰 정보 갱신함
                    // 인덱스는 0번 부터 시작하며 초기 값은 0
                    PetController().updateSelectedPetInfo(snapshot, petController, petController.selectedPetScrollIndex);

                    return Column(
                      children: [
                        // 좌우 스크롤 슬라이더
                        CarouselSlider.builder(
                          options: CarouselOptions(
                            viewportFraction: 0.5,
                            enlargeCenterPage : true,
                            enlargeFactor : 0.4,
                            enableInfiniteScroll: false,
                            onPageChanged: (index, reason) {
                              setState(() {
                                PetController().updateSelectedPetInfo(snapshot, petController, index);
                              });
                            },
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, itemIndex, pageViewIndex) {
                            return CircleAvatar(
                              radius: size.width * 0.3,
                              child: ClipOval(
                                child: FadeInImage.memoryNetwork(
                                  fit: BoxFit.cover,
                                  placeholder: kTransparentImage,
                                  image: snapshot.data!.docs[itemIndex].get('imageUrl'),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: size.height * 0.001),
                        Center(
                          child: Container(
                            height: petInfoHeight,
                            width: petInfoWidth,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  blurRadius: 5.0,
                                  spreadRadius: 0.0,
                                  offset: const Offset(0, 7),
                                )
                              ],
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(petInfoWidth * 0.05, size.width * 0.05, petInfoWidth * 0.05, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 이름
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        infoTitleBox(petInfoWidth, petInfoHeight, '이름'),
                                        SizedBox(
                                          width: petInfoWidth * 0.03,
                                        ),
                                        Text(
                                          snapshot.data!.docs[petController.selectedPetScrollIndex].get('name'),
                                          style: TextStyle(
                                            fontSize: size.width * 0.05,
                                            color: Color(0xff504E5B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: petInfoHeight * 0.02,
                                    ),
                                    // 성별
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        infoTitleBox(petInfoWidth, petInfoHeight, '성별'),
                                        SizedBox(
                                          width: petInfoWidth * 0.03,
                                        ),
                                        Container(
                                          child: snapshot.data!.docs[petController.selectedPetScrollIndex].get('gender') == 'Male'
                                              ? Icon(Icons.male, color: Colors.blueAccent,)
                                              : Icon(Icons.female, color: Colors.pink,),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: petInfoHeight * 0.02,
                                    ),
                                    // 생일
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        infoTitleBox(petInfoWidth, petInfoHeight, '생일'),
                                        SizedBox(
                                          width: petInfoWidth * 0.03,
                                        ),
                                        Text(
                                          snapshot.data!.docs[petController.selectedPetScrollIndex].get('birth'),
                                          style: TextStyle(
                                            fontSize: size.width * 0.05,
                                            color: Color(0xff504E5B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: petInfoHeight * 0.02,
                                    ),
                                    // 카테고리
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        infoTitleBox(petInfoWidth, petInfoHeight, '분류'),
                                        SizedBox(
                                          width: petInfoWidth * 0.03,
                                        ),
                                        Text(
                                          snapshot.data!.docs[petController.selectedPetScrollIndex].get('kategorie'),
                                          style: TextStyle(
                                            fontSize: size.width * 0.05,
                                            color: Color(0xff504E5B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: petInfoHeight * 0.02,
                                    ),
                                    // 견종
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        infoTitleBox(petInfoWidth, petInfoHeight, '견종'),
                                        SizedBox(
                                          width: petInfoWidth * 0.03,
                                        ),
                                        Container(
                                          width: petInfoWidth * 0.3,
                                          height: petInfoHeight * 0.06,
                                          child: AutoSizeText(
                                            snapshot.data!.docs[petController.selectedPetScrollIndex].get('breed'),
                                            minFontSize: 1,
                                            style: TextStyle(
                                                color: Color(0xff504E5B),
                                                fontSize: size.width * 0.05,
                                                overflow: TextOverflow.ellipsis
                                            ),
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: petInfoHeight * 0.02,
                                    ),
                                    // 몸무게
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        infoTitleBox(petInfoWidth, petInfoHeight, '무게'),
                                        SizedBox(
                                          width: petInfoWidth * 0.03,
                                        ),
                                        Text(
                                          snapshot.data!.docs[petController.selectedPetScrollIndex].get('weight') == 0
                                              ? '몸무게 미입력'
                                              : '${snapshot.data!.docs[petController.selectedPetScrollIndex].get('weight')}kg',
                                          style: TextStyle(
                                            color: Color(0xff504E5B),
                                            fontSize: size.width * 0.05,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: petInfoHeight * 0.02,
                                    ),
                                    // 권장 산책 시간
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        infoTitleBox(petInfoWidth, petInfoHeight, '하루 권장 산책 시간'),
                                        SizedBox(
                                          width: petInfoWidth * 0.03,
                                        ),
                                        Text(
                                          '${(snapshot.data!.docs[petController.selectedPetScrollIndex].get('recommend') / 60).toInt()}시간 ${snapshot.data!.docs[petController.selectedPetScrollIndex].get('recommend') % 60}분',
                                          style: TextStyle(
                                            color: Color(0xff504E5B),
                                            fontSize: size.width * 0.05,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: petInfoHeight * 0.07,
                                    ),
                                    //편집하기 버튼
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // 편집 상태
                                          mypageStateController.myPageStateType = MyPageStateType.Edit;

                                          // 편집 페이지로 이동
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditDogInfoPage()));
                                        },
                                        child: Text('편집하기'),
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Color(0xff646CAA)),
                                          foregroundColor: MaterialStateProperty.all(Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
