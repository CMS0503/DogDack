# DogDack 반려견과의 추억 간직 서비스

![eeee](/uploads/667115d799692235868090912b84d1d6/eeee.png)

## [DogDack Play 스토어 다운로드](https://play.google.com/store/apps/details?id=com.common.pjt.dogdack&pli=1)

## ▶️ 소개 영상 보기 :

## 📆 프로젝트 진행 기간

2023.01.03(화) ~ 2023.02.17(금) (45일간 진행)
SSAFY 8기 2학기 공통프로젝트 - DogDack

![스크린샷_2023-02-17_오전_5.01.37](/uploads/77f8bb2575d0ce9b535a1df02e96327e/스크린샷_2023-02-17_오전_5.01.37.png)


## 🐶 DogDack - 배경


DogDack은 시간이 지나면 잊기 쉬운 반려견과의 추억을 기록하고 반려견의 일상을 돌아보기 위해 탄생한 온 가족 통합 반려견 케어 어플리케이션이에요.

- DogDack은 반려견의 산책 경로를 트랙킹하는 기능을 제공하고 목욕, 미용 등의 반려견 정보를 꼼꼼하게 저장해 온 가족이 한눈에 파악할 수 있는 우리가족 반려견 케어 어플리케이션이에요.

## 🐶 앱 주요 기능


- 홈 화면
    - 강아지들의 오늘 산책 달성량을 확인할 수 있어요.
    - 강아지들과 태어난 날로 부터 몇 일을 함께 했는지 알 수 있어요.
    - 주별로 강아지들의 산책 여부를 한 눈에 확인할 수 있어요.
    - 강아지들과 어느 시간에 산책을 많이 했는지 한 눈에 확인할 수 있어요.
- 산책 화면
    - 산책 시킬 강아지들을 선택하고 산책을 시작할 수 있어요.
    - 강아지가 메고 있는 가방의 GPS를 통해 산책 경로를 기록할 수 있어요.
    - 강아지가 어두운 환경에 가면 메고 있는 가방의 조도 센서를 통해 LED Strip을 켜서 안전한 산책을 진행할 수 있어요.
    - 강아지를 잃어버렸을 때 가방의 GPS를 통해 마지막 위치를 알 수 있어요.
    - 산책 목표를 직접 정하고 목표 달성률을 볼 수 있어서 산책에 동기부여를 줄 수 있어요
    - 산책 시간, 거리를 제공하여 더 효율적인 산책을 할 수 있어요.
- 캘린더 화면
    - 일별 반려견 정보 수동 기록
        - 자동으로 기록하지 못한 과거 혹은 오늘의 산책 기록을 캘린더의 추가하기(+) 버튼을 눌러 기록할 수 있어요.
        - 오늘 산책한 장소, 시간, 거리 정보와 산책 중 즐거웠던 순간을 사진으로 남겨 반려견과의 소중한 추억을 간직하세요.
        - 기록하지 않으면 기억하기 힘든 반려견의 목욕과 미용 기록 또한 꼼꼼하게 남겨보세요.
        - 기록된 정보는 계정 공유를 통해 온가족이 함께 확인할 수 있어요. 불필요한 산책과 목욕, 미용을 방지할 수 있어요!
        - 반려견이 여러 마리라도 서로 별도의 달력에 기록해 헷갈림 없이 기록할 수 있어요.
        - 캘린더의 일별 마크는 색으로 구분돼 월 단위의 정보를 한눈에 파악할 수 있어요.
    - 캘린더 상세페이지
        - 캘린더의 마커를 클릭해 상세페이지에서 되돌아보고 싶은 반려견과의 기록을 추억해 보세요.
        - 그간 기록했던 산책기록과 정보, 그날의 일기를 추억할 수 있어요.
        - 수정하고 싶은 기록은 편집 버튼을 클릭해 원하는 사진, 일기 등으로 수정할 수 있어요.
        - GPS를 통해 자동으로 기록된 정보에 일기를 추가해 그날의 기억을 풍성하게 관리할 수 있어요.

- 차트 화면
    - 지난 일주일 혹은 한달 간의 산책 기록을 한눈에 파악할 수 있어요.
    - 저번주, 저번달과 이번주, 이번달의 산책 기록을 비교할 수 있어요.
- 마이페이지 화면
    - 강아지들과 함께 했던 총 산책 횟수, 산책 시간, 강아지 수를 확인할 수 있어요.
    - 강아지들의 정보를 추가하고 편집하고 삭제할 수 있어요.
        - 강아지 이름, 성별, 생일, 분류, 견종, 무게
    - 전화 번호를 등록하여 IoT 기기의 LCD 화면에 전화 번호를 표시할 수 있어요.
    - 함께 돌보기 기능으로 다른 계정의 강아지 정보를 함께 관리할 수 있어요.

## ✔ 주요 기술


**Frontend - Flutter**

- IDE
    - Android Studio
    - VS Code
- Flutter 3.7.3

**Backend - Firebase**

- Firebase Authentication
- Firebase Database
- Firebase Storage

**Embedded**

- Arduino
- GPS
- Bluetooth
- LED, LCD

## ✔ 시스템 아키텍쳐

![화면_캡처_2023-02-17_105112](/uploads/6c0b04afdd3bc0cc4844875f0acb1198/화면_캡처_2023-02-17_105112.png)


## ✔ DB 구조 (Firebase - NoSQL)


DogDack 서비스의 Firestore Database 구조는 다음과 같습니다.

- Users (Collection)
    - 이메일주소 (Document)
        - Pets (Collection)
            - AutoID (Document)
                - String `imageUrl` : 반려견 사진 URL 주소 .
                    - 사진 저장 경로 : 이메일주소/dogs/이미지 파일명
                - String `imageFileName` : Firebase Storage 에 저장된 반려견 사진의 파일명.
                - String `name` : 반려견 이름 (다른 문서에서 중복될 수 없도록 처리)
                - String `gender` : 반려견 성별
                - String `birth` : 반려견 생일
                - String `kategorie` : 반려견 견종 분류
                - String `breed` : 반려견 견종
                - num `weight` : 반려견 체중
                - num `recommend` : 반려견 권장 산책 시간(단위 : min)
                - Timestamp `createdAt` : 데이터 최초 생성 시간
                - Calender (Collection)
                    - 날짜 (Document) ex) 20230201
                        - bool `isWalk` : 해당 일자 산책 여부
                        - bool `beauty` : 해당 일자 미용 여부
                        - bool `bath` : 목욕 여부
                        - List `imageUrl` : 오늘의 일기 사진 URL
                        - String `diary` : 오늘의 일기 내용
                - Walk (Collection)
                    - AutoID (Document)
                        - String `imageUrl` : 산책한 경로 이미지
                        - Timestamp `startTime` : 산책 시작 시간
                        - Timestamp `endTime` : 산책 종료 시간
                        - num `totalTimeMin` : 실제로 산책한 시간. 분 단위 (일시정지있는 경우 필요)
                        - bool `isAuto` : 해당 산책 Document 의 자동(true) 입력 / 수동(false) 입력 여부
                        - String `place` : 대표 산책 장소
                        - num `distance` : 이동 거리(단위 : m)
                        - num `goal`목표 산책 시간(단위 : min)
        - UserInfo (Collection)
            - information (document)
                - String `hostEmail` : 로그인하고자 하는 호스트 계정 (초기값 : “”)
                - bool `isHost` : 호스트 계정 이메일로 접속할 것인지 여부 (true : 호스트 계정으로 접속) (초기값 : false)
                - String `password` : 호스트 계정이 설정한 비밀번호 (다른 계정이 자기 자신의 계정의 데이터를 읽어오기 위한 자기 자신의 비밀번호) (초기값 : “”)
                - String `phoneNumber` : 핸드폰 번호. (초기 값 : “”)

## ✔ 협업 환경


- Git
    - 코드 버전 관리
    - Wiki 로 코딩 컨벤션과 Firebase Database 구조 관리 및 공유
- Notion
    - 회의록 관리
- Jira
    - 주차별 스프린트 관리
    - 업무 분배 및 Story Point 할당
    - 번다운 차트 관리
- MatterMost
    - 일일 데일리 스크럼 회의를 진행하여 프로젝트 진행 상황 관리
- Discord
    - 온라인 환경에서 코드 리뷰 및 기능 회의
- Figma
    - 어플리케이션 UI / UX 디자인 회의

## ✔ 팀원 역할 분배

![KakaoTalk_20230217_093622763](/uploads/febc2cb7126e10a9c52cb110fa06dfe1/KakaoTalk_20230217_093622763.png)
![KakaoTalk_20230217_093622763_01](/uploads/bfe1546ac6e06ae4482bff2ba573e120/KakaoTalk_20230217_093622763_01.png)

## ✔ 프로젝트 산출물


- WBS
    - ![그림11](/uploads/109d0714767a451a8c3a17fa907fc879/그림11.png)
- [Notion](https://www.notion.so/062ce32c4c924004a8b374baefbbd380)
- [Figma](https://www.figma.com/file/YIcvIFtKxzEPv62Y0DtOrs/%EC%A7%AC%EB%BD%95%EC%9D%B4%EB%9E%91-%EA%B3%B5%EC%88%99%EC%9D%B4?node-id=0%3A1&t=2vODEjucgk24CHPx-0)
- [요구사항정의서](https://docs.google.com/spreadsheets/d/1KX3JVyPeaAxugV7oKzjsiHAYqiBOyCJsUJqaBZuL45k/edit?usp=sharing)

## ✔ 프로젝트 결과물
### 로그인 후 첫 화면
<img src="/uploads/52b8a79dbdc5890b5aa793d6f31cf604/KakaoTalk_20230217_101951663_21.jpg" width="200" height="400"/>

### 마이 페이지
<img src="/uploads/2350a23e05012a1c26ae00b8e00324fa/KakaoTalk_20230217_101951663_17.jpg" width="200" height="400"/>
<img src="/uploads/7e3b67976db89e6b7d2f345716183447/KakaoTalk_20230217_101951663_16.jpg" width="200" height="400"/>
<img src="/uploads/bb12724fb5077171e613dcda0a800c7f/KakaoTalk_20230217_101951663_15.jpg" width="200" height="400"/>
<img src="/uploads/b9810ebbc5618714fc42b11b1f624e2d/KakaoTalk_20230217_101951663_14.jpg" width="200" height="400"/>
<img src="/uploads/0ae98e4145f6da343f0e585258c61e17/KakaoTalk_20230217_101951663_12.jpg" width="200" height="400"/>


### 산책 페이지
<img src="/uploads/10ef5ce7c0a5391a47a916fa190ceba8/KakaoTalk_20230217_101951663_20.jpg" width="200" height="400"/>
<img src="/uploads/17e213b13c7a827d7f857742918b555e/KakaoTalk_20230217_101951663_08.jpg" width="200" height="400"/>
<img src="/uploads/642d1e235a194c050e29424261d2a117/KakaoTalk_20230217_111100560_02.png" width="200" height="400"/>

<img src="/uploads/846928898875354812a07b14fce45734/KakaoTalk_20230217_111100560_01.png" width="200" height="400"/>

<img src="/uploads/35a771a17f8c9fe4e868c082833b1f46/KakaoTalk_20230217_101951663_07.jpg" width="200" height="400"/>
<img src="/uploads/72b010c73620b4aa2eb4c67534fef9e5/KakaoTalk_20230217_101951663_06.jpg" width="200" height="400"/>
<img src="/uploads/71fcfc35155828b84da40ffd6e1bedb3/KakaoTalk_20230217_101951663_05.jpg" width="200" height="400"/>


### 차트 페이지
<img src="/uploads/70e3150f17d3d9b6888ced76f6af862f/KakaoTalk_20230217_111100560_03.png" width="200" height="400"/>
<img src="/uploads/2bfd63ca548664f1b8909fb8f85d7f99/KakaoTalk_20230217_111100560_06.png" width="200" height="400"/>

### 캘린더 페이지
<img src="/uploads/0379e8f609f2f34ec962cf03d8ad991c/KakaoTalk_20230217_101951663_02.jpg" width="200" height="400"/>
<img src="/uploads/a1701fa958dd6e25502c0887f96ad32a/KakaoTalk_20230217_111100560_04.png" width="200" height="400"/>

### 캘린더 스케줄 관리
<img src="/uploads/7553bda0bcff00e4cb9a41a9c97aef4e/KakaoTalk_20230217_101951663_04.jpg" width="200" height="400"/>
<img src="/uploads/950bbf55bbfc1dd80ad95e4b93555012/KakaoTalk_20230217_101951663_03.jpg" width="200" height="400"/>

### 홈페이지
<img src="/uploads/70e3150f17d3d9b6888ced76f6af862f/KakaoTalk_20230217_111100560_03.png" width="200" height="400"/>
