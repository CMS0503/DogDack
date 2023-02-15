import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dogdack/controllers/mypage_floatingbtn_controller.dart';
import 'package:dogdack/controllers/user_controller.dart';
import 'package:dogdack/models/user_data.dart';
import 'package:dogdack/screens/my/widgets/mypage_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:restart_app/restart_app.dart';
import '../../commons/logo_widget.dart';
import '../../controllers/main_controll.dart';
import '../../controllers/mypage_controller.dart';
import 'package:dogdack/models/dog_data.dart';
import 'editinfo_screen.dart';
import 'package:animated_floating_buttons/animated_floating_buttons.dart';

class MyPage extends StatefulWidget {
  MyPage({super.key});

  final inputController = TextEditingController();

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  //CollectionReference
  late CollectionReference<DogData> petsRef;
  late CollectionReference<UserData> userRef;
  late CollectionReference<UserData> myRef;

  //BuildContext context
  late BuildContext globalContext;

  //Size
  late Size deviceSize;

  //GetX
  final petController = Get.put(PetController());
  final mypageStateController = Get.put(MyPageStateController());
  final mainController = Get.put(MainController());
  final userController = Get.put(UserController());
  final floatingController = Get.put(MyPageFloatingBtnController());

  //Colors
  Color floatingBtnColor_total = Color(0xff644CAA);
  Color floatingBtnChild = Colors.grey;
  Color floatingGuideTextBox = Color.fromARGB(211, 90, 90, 90);

  //Widgets
  // 정보 화면 타이틀 위젯
  Container infoTitleBox(double cardWith, double cardHeight, String title) {
    return Container(
      width: cardWith * 0.4,
      height: cardHeight * 0.08,
      decoration: BoxDecoration(
        border: Border.all(color: floatingBtnColor_total, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: floatingBtnColor_total,
            fontSize: cardWith * 0.06,
          ),
        ),
      ),
    );
  }

  //Floating button List
  Widget petAddBtn() {
    return Container(
      child: Row(
        children: [
          Container(
            child: Text('강아지 추가', style: TextStyle(color: Colors.white),),
            padding: EdgeInsets.all(deviceSize.width * 0.02),
            decoration: BoxDecoration(
              color: floatingGuideTextBox,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(width: deviceSize.width * 0.02),
          FloatingActionButton(
            onPressed: () {
              //페이지 옵션 -> 추가하기 화면
              mypageStateController.myPageStateType = MyPageStateType.Create;

              floatingController.floatBtnKey.currentState?.closeFABs();

              // 반려견 정보 추가 페이지로 이동
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditDogInfoPage()));
            },
            heroTag: "petAddBtn",
            tooltip: '강아지 추가',
            child: Icon(Icons.pets, color: Colors.white),
            backgroundColor: floatingBtnChild,
          ),
        ],
      ),
    );
  }

  Widget phoneBtn() {
    return Container(
      child: Row(
        children: [
          Container(
            child: Text('전화번호 등록', style: TextStyle(color: Colors.white),),
            padding: EdgeInsets.all(deviceSize.width * 0.02),
            decoration: BoxDecoration(
              color: floatingGuideTextBox,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(width: deviceSize.width * 0.02),
          FloatingActionButton(
            onPressed: () {
              floatingController.floatBtnKey.currentState?.closeFABs();

              String phNum = '아직 번호가 등록 되지 않았어요!';
              userRef.get().then((value) {
                String phoneNumber =  value.docs[0].get('phoneNumber').toString();
                if(phoneNumber.length != 0) {
                  phNum = phoneNumber;
                }

                showTextInputDialog(
                  context: globalContext,
                  title: '전화 번호',
                  message: '현재 전화 번호 \n\n ${phNum}',
                  okLabel: '확인',
                  cancelLabel: '취소',
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
                    MyPageSnackBar().notfoundDogData(globalContext, SnackBarErrorType.PhoneNumberNotExist);
                    return;
                  }

                  userRef.doc('information').update(map)
                      .whenComplete(() => print('변경 완료'))
                      .catchError((error) => print('전화번호 저장 오류! ${error}'));
                });
              });
            },
            heroTag: "phoneBtn",
            tooltip: '전화번호 등록',
            child: Icon(Icons.phone_android, color: Colors.white),
            backgroundColor: floatingBtnChild,
          ),
        ],
      ),
    );
  }

  Widget joinGroupBtn() {
    return Container(
      child: Row(
        children: [
          Container(
            child: Text('그룹 가입하기', style: TextStyle(color: Colors.white),),
            padding: EdgeInsets.all(deviceSize.width * 0.02),
            decoration: BoxDecoration(
              color: floatingGuideTextBox,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(width: deviceSize.width * 0.02),
          FloatingActionButton(
            onPressed: () {
              floatingController.floatBtnKey.currentState?.closeFABs();

              showTextInputDialog(
                  context: globalContext,
                  title: '그룹 가입하기',
                  message: '강아지 정보를 공유 받고 싶은 그룹의 호스트 계정 이메일과 그룹 비밀번호를 입력하세요!',
                  okLabel: '확인',
                  cancelLabel: '취소',
                  textFields: [
                    DialogTextField(
                      keyboardType: TextInputType.emailAddress,
                      hintText: '이메일을 입력하세요',
                    ),
                    DialogTextField(
                      keyboardType: TextInputType.number,
                      hintText: '비밀번호를 입력하세요',
                    )
                  ]
              ).then((inputValue) {
                // 취소를 누를 경우
                if(inputValue == null)
                  return;

                // 문서 중에 해당하는 이름의 문서를 찾는다.
                FirebaseFirestore.instance.collection('Users').doc(inputValue.elementAt(0)).get().then((emailValue) {
                  if(emailValue.exists) {
                    // 해당하는 이름의 문서가 있으면 계정의 비밀번호와 비교
                    FirebaseFirestore.instance.collection('Users/${inputValue.elementAt(0)}/UserInfo').get().then((hostDoc) {
                      String hostPass = hostDoc.docs[0].get('password');
                      String inputPass = inputValue.elementAt(1);

                      if(inputPass.length != 0 && hostPass.compareTo(inputPass) == 0) {
                        //로그인 성공
                        //내 계정에 호스트 이메일을 등록함.
                        var map = Map<String, dynamic>();
                        map['hostEmail'] = inputValue.elementAt(0).toString();
                        map['isHost'] = true;

                        userRef.doc('information').update(map)
                            .whenComplete(() => Restart.restartApp())
                            .catchError((error) {
                          MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.InvalidLogin);
                        });
                      } else {
                        MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.InvalidLogin);
                      }
                    });
                  } else {
                    return MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.EmailNotExist);
                  }
                });
              });
            },
            heroTag: "joinGroupBtn",
            tooltip: '그룹 가입하기',
            child: Icon(Icons.login, color: Colors.white),
            backgroundColor: floatingBtnChild,
          ),
        ],
      ),
    );
  }

  Widget showMemberBtn() {
    return Container(
      child: Row(
        children: [
          Container(
            child: Text('그룹 멤버보기', style: TextStyle(color: Colors.white),),
            padding: EdgeInsets.all(deviceSize.width * 0.02),
            decoration: BoxDecoration(
              color: floatingGuideTextBox,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(width: deviceSize.width * 0.02),
          FloatingActionButton(
            onPressed: () {
              floatingController.floatBtnKey.currentState?.closeFABs();
            },
            heroTag: "showMemberBtn",
            tooltip: '그룹 멤버보기',
            child: Icon(Icons.groups, color: Colors.white),
            backgroundColor: floatingBtnChild,
          ),
        ],
      ),
    );
  }

  Widget guestGroupOut() {
    return Container(
      child: Row(
        children: [
          Container(
            child: Text('그룹 나가기', style: TextStyle(color: Colors.white),),
            padding: EdgeInsets.all(deviceSize.width * 0.02),
            decoration: BoxDecoration(
              color: floatingGuideTextBox,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(width: deviceSize.width * 0.02),
          FloatingActionButton(
            onPressed: () {
              floatingController.floatBtnKey.currentState?.closeFABs();

              showOkCancelAlertDialog(
                context: globalContext,
                cancelLabel: '취소',
                okLabel: '확인',
                title: '그룹 나가기',
                message: '현재 가입된 그룹에서 정말 나가시겠습니까?\n(확인을 누르면 앱이 재시작됩니다.)',
              ).then((isOKPress) {
                if(isOKPress == OkCancelResult.cancel)
                  return;

                var map = Map<String, dynamic>();
                map['hostEmail'] = '';
                map['isHost'] = false;

                myRef.doc('information').update(map)
                    .whenComplete(() => Restart.restartApp())
                    .catchError((error) => print(error));
              });
            },
            heroTag: "guestGroupOut",
            tooltip: '그룹 나가기',
            child: Icon(Icons.logout, color: Colors.white),
            backgroundColor: floatingBtnChild,
          ),
        ],
      ),
    );
  }

  Widget setPassword() {
    return Container(
      child: Row(
        children: [
          Container(
            child: Text('그룹 비밀번호 설정', style: TextStyle(color: Colors.white),),
            padding: EdgeInsets.all(deviceSize.width * 0.02),
            decoration: BoxDecoration(
              color: floatingGuideTextBox,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(width: deviceSize.width * 0.02),
          FloatingActionButton(
            onPressed: () {
              floatingController.floatBtnKey.currentState?.closeFABs();

              String getPassword = '아직 비밀번호가 등록되지 않았어요!';
              myRef.get().then((myDBPass) {
                String dbPassword = myDBPass.docs[0].get('password').toString();
                if(dbPassword.length != 0) {
                  getPassword = dbPassword;
                }

                showTextInputDialog(
                    context: globalContext,
                    title: '공유 비밀번호 설정',
                    message: '나와 강아지 정보를 공유하고 싶은 사람에게 비밀번호를 알려주세요!\n현재 비밀번호 : ${getPassword}',
                    textFields: [
                      DialogTextField(
                        keyboardType: TextInputType.number,
                        hintText: '비밀번호를 입력하세요',
                      )
                    ],
                ).then((pressPassword) {
                  // 취소를 누를 경우
                  if(pressPassword == null)
                    return;

                  var map = Map<String, dynamic>();
                  map['password'] = pressPassword.elementAt(0).toString();

                  if(pressPassword.elementAt(0).toString().length == 0) {
                    MyPageSnackBar().notfoundDogData(context, SnackBarErrorType.PasswordNotExist);
                    return;
                  }

                  myRef.doc('information').update(map)
                      .whenComplete(() => print('변경 완료'))
                      .catchError((error) => print('전화번호 저장 오류! ${error}'));
                });
              });
            },
            heroTag: "setPassword",
            tooltip: '그룹 비밀번호 설정',
            child: Icon(Icons.lock, color: Colors.white),
            backgroundColor: floatingBtnChild,
          ),
        ],
      ),
    );
  }

  //Functions
  // 총 산책 시간 계산
  Stream<num> getTotalWalkMin() async* {
    num totalWalkMin = 0; // 총 산책 시간
    CollectionReference petRef = FirebaseFirestore.instance.collection('Users/${userController.loginEmail}/Pets');
    QuerySnapshot _docInPets = await petRef.get();
    for (int i = 0; i < _docInPets.docs.length; i++) {
      String _docInPetsID = _docInPets.docs[i].id; // Pets Collection 아래 문서 이름 (반려견 이름)
      CollectionReference walkRef = petsRef.doc('${_docInPetsID}').collection('Walk');
      QuerySnapshot _docInWalk = await walkRef.get();
      for (int j = 0; j < _docInWalk.docs.length; j++) {
        totalWalkMin += _docInWalk.docs[j]['totalTimeMin'];
      }
    }

    totalWalkMin = (totalWalkMin / 60).toInt();

    yield totalWalkMin;
  }

  // 총 산책 횟수 계산
  Stream<num> getTotalWalkCnt() async* {
    num totalWalkCnt = 0; // 총 산책 횟수
    CollectionReference petRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets');
    QuerySnapshot _docInPets = await petRef.get();
    for (int i = 0; i < _docInPets.docs.length; i++) {
      String _docInPetsID =
          _docInPets.docs[i].id; // Pets Collection 아래 문서 이름 (반려견 이름)
      CollectionReference walkRef =
      petsRef.doc('${_docInPetsID}').collection('Walk');
      QuerySnapshot _docInWalk = await walkRef.get();
      totalWalkCnt += _docInWalk.docs.length;
    }

    yield totalWalkCnt;
  }

  @override
  void initState() {
    super.initState();

    //총 산책 시간, 총 산책 횟수 계산
    getTotalWalkMin();
    getTotalWalkCnt();
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    //CollectionReference initialization
    petsRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/Pets')
        .withConverter(
        fromFirestore: (snapshot, _) => DogData.fromJson(snapshot.data()!),
        toFirestore: (dogData, _) => dogData.toJson());

    userRef = FirebaseFirestore.instance
        .collection('Users/${userController.loginEmail}/UserInfo')
        .withConverter(
        fromFirestore: (snapshot, _) => UserData.fromJson(snapshot.data()!),
        toFirestore: (userData, _) => userData.toJson());

    myRef = FirebaseFirestore.instance
        .collection('Users/${FirebaseAuth.instance.currentUser!.email}/UserInfo')
        .withConverter(
        fromFirestore: (snapshot, _) => UserData.fromJson(snapshot.data()!),
        toFirestore: (userData, _) => userData.toJson());

    //Size
    deviceSize = MediaQuery.of(context).size; // 디바이스 사이즈
    final double petInfoWidth = deviceSize.width * 0.9; // 강아지 정보 표시 카드 너비
    final double petInfoHeight = deviceSize.height * 0.42; // 강아지 정보 표시 카드 높이

    //총 산책 시간, 총 산책 횟수 계산
    getTotalWalkMin();
    getTotalWalkCnt();

    return GestureDetector(
      onTap: () {
        //포커스를 벗어나면 키보드를 해제함
        FocusManager.instance.primaryFocus?.unfocus();

        if(floatingController.floatBtnKey.currentState?.isOpened == true)
          floatingController.floatBtnKey.currentState?.closeFABs();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(deviceSize.height * 0.08),
          child: const LogoWidget(),
        ),
        floatingActionButton: AnimatedFloatingActionButton(
          fabButtons: userController.isHost ? <Widget>[
              petAddBtn(), phoneBtn(), guestGroupOut(),] : <Widget>[
              petAddBtn(), phoneBtn(), joinGroupBtn(), setPassword()],
          colorStartAnimation: floatingBtnColor_total,
          colorEndAnimation: Colors.red,
          key: floatingController.floatBtnKey,
          animatedIconData: AnimatedIcons.menu_close,
        ),
        // 키보드 등장 시 화면 오버플로우가 발생하지 않도록 함.
        body: SingleChildScrollView(
          child: Padding(
            // body 내 모든 위젯의 padding 설정
            padding: EdgeInsets.fromLTRB(0, deviceSize.height * 0.03, 0, 0),
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
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: deviceSize.width * 0.10,
                              backgroundImage: CachedNetworkImageProvider(FirebaseAuth.instance.currentUser!.photoURL.toString()),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.01,
                            ),
                            // 사용자 닉네임
                            Container(
                              width: deviceSize.width * 0.2,
                              child: Text(
                                FirebaseAuth.instance.currentUser!.displayName.toString(),
                                style: TextStyle(
                                  fontSize: deviceSize.width * 0.04,
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
                            SizedBox(height: deviceSize.height * 0.02),
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
                            SizedBox(height: deviceSize.height * 0.02),
                            Text('산책 시간'),
                          ],
                        ),
                        // 반려견 수
                        Column(
                          children: [
                            Text(petSnapshot.data!.docs.length.toString()),
                            SizedBox(height: deviceSize.height * 0.02),
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
                        padding: EdgeInsets.fromLTRB(0, deviceSize.height * 0.3, 0, 0),
                        child: Text('댕댕이를 등록해주세요!'),
                      );
                    }

                    // 여기서 부터는 등록된 반려견이 1마리 이상 존재함.

                    // 마지막으로 저장된 스크롤 인덱스에 맞춰 정보 갱신함
                    // 인덱스는 0번 부터 시작하며 초기 값은 0
                    PetController().updateSelectedPetInfo(snapshot, petController, petController.selectedPetScrollIndex);

                    petController.petNameList.clear();
                    for(int petIdx = 0; petIdx < snapshot.data!.docs.length; petIdx++) {
                      petController.petNameList.add(snapshot.data!.docs[petIdx].get('name'));
                    }

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
                              radius: deviceSize.width * 0.25,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data!.docs[itemIndex].get('imageUrl'),
                                  progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: deviceSize.height * 0.001),
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
                                padding: EdgeInsets.fromLTRB(deviceSize.width * 0.05, deviceSize.width * 0.05, deviceSize.width * 0.05, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 이름
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        infoTitleBox(deviceSize.width * 0.8, deviceSize.height * 0.5, '이  름'),
                                        SizedBox(
                                          width: petInfoWidth * 0.03,
                                        ),
                                        Text(
                                          snapshot.data!.docs[petController.selectedPetScrollIndex].get('name'),
                                          style: TextStyle(
                                            fontSize: deviceSize.width * 0.05,
                                            color: Color(0xff504E5B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: deviceSize.height * 0.01,
                                    ),
                                    // 성별
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        infoTitleBox(deviceSize.width * 0.8, deviceSize.height * 0.5, '성  별'),
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
                                      height: deviceSize.height * 0.01,
                                    ),
                                    // 생일
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        infoTitleBox(deviceSize.width * 0.8, deviceSize.height * 0.5, '생  일'),
                                        SizedBox(
                                          width: petInfoWidth * 0.03,
                                        ),
                                        Text(
                                          snapshot.data!.docs[petController.selectedPetScrollIndex].get('birth'),
                                          style: TextStyle(
                                            fontSize: deviceSize.width * 0.05,
                                            color: Color(0xff504E5B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: deviceSize.height * 0.01,
                                    ),
                                    // 카테고리
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        infoTitleBox(deviceSize.width * 0.8, deviceSize.height * 0.5, '분  류'),
                                        SizedBox(
                                          width: deviceSize.width * 0.03,
                                        ),
                                        Text(
                                          snapshot.data!.docs[petController.selectedPetScrollIndex].get('kategorie'),
                                          style: TextStyle(
                                            fontSize: deviceSize.width * 0.05,
                                            color: Color(0xff504E5B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: deviceSize.height * 0.01,
                                    ),
                                    // 견종
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        infoTitleBox(deviceSize.width * 0.8, deviceSize.height * 0.5, '견  종'),
                                        SizedBox(
                                          width: deviceSize.width * 0.03,
                                        ),
                                        Container(
                                          width: deviceSize.width * 0.3,
                                          height: deviceSize.height * 0.03,
                                          child: AutoSizeText(
                                            snapshot.data!.docs[petController.selectedPetScrollIndex].get('breed'),
                                            minFontSize: 1,
                                            style: TextStyle(
                                                color: Color(0xff504E5B),
                                                fontSize: deviceSize.width * 0.05,
                                                overflow: TextOverflow.ellipsis
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: deviceSize.height * 0.01,
                                    ),
                                    // 몸무게
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        infoTitleBox(deviceSize.width * 0.8, deviceSize.height * 0.5, '무  게'),
                                        SizedBox(
                                          width: petInfoWidth * 0.03,
                                        ),
                                        Text(
                                          snapshot.data!.docs[petController.selectedPetScrollIndex].get('weight') == 0
                                              ? '몸무게 미입력'
                                              : '${snapshot.data!.docs[petController.selectedPetScrollIndex].get('weight')}kg',
                                          style: TextStyle(
                                            color: Color(0xff504E5B),
                                            fontSize: deviceSize.width * 0.05,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: deviceSize.height * 0.02,
                                    ),
                                    //편집하기 버튼
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          floatingController.floatBtnKey.currentState?.closeFABs();

                                          // 편집 상태
                                          mypageStateController.myPageStateType = MyPageStateType.Edit;

                                          // 편집 페이지로 이동
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditDogInfoPage()));
                                        },
                                        child: Text('편집하기'),
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(floatingBtnColor_total),
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
                SizedBox(
                  height: deviceSize.height * 0.05,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
