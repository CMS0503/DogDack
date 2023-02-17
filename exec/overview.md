
## 형상 관리
- Gitlab

## 이슈 관리
- Jira

## 커뮤니케이션
- MettaMost
- Webex
- discord
- Notion

## OS
- android

## UX/UI
- figma
- PowerPoint

## IDE
- androidStudio 2021.3.1
- visualStudio Code 1.68

## Server
- firebase

## DataBase
- firebase

## FrontEnd
- flutter 3.7.3

## IoT
- Arduino Uno
- GPS module
- Photoresister
- LED strip
- LCD pannel module
- Bluetooth jdy-16

## Language
- Dart
- C



# FireBase 설치 메뉴얼
- firebase console 접속
    - https://console.firebase.google.com/

- firebase dataBase 프로젝트 생성
     - img
    
- firebase flutter 프로젝트 생성
    - img

- Windows용 Firebase CLI 바이너리 다운
    - https://firebase.google.com/docs/cli?authuser=0&hl=ko#install-cli-windows

- 명령어 실행
    - curl -sL https://firebase.tools | bash

- firebase 로그인
    - firebase login

## Flutter 설치 메뉴얼
- flutter SDK 설치
    - https://docs.flutter.dev/get-started/install?authuser=0&hl=ko

- flutter 프로젝트 시작
    - firebase CLI 에서 명령어 입력
    - flutter create


- FlutterFire CLI 설치 및 실행
    - 생성된 플러터 프로젝트 안에서 명령어 실행
    - dart pub global activate flutterfire_cli
    - flutterfire configure --project=fabled-gist-349101

- Firebase 초기화 및 플러그인 추가
    - Firebase를 초기화하려면 새 firebase_options.dart 파일의 구성으로 firebase_core 패키지에서 Firebase.initializeApp을 호출
    - import 'package:firebase_core/firebase_core.dart';
        import 'firebase_options.dart';

        // ...

        await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
        );

- flutter 플러그인 추가
    - https://firebase.google.com/docs/flutter/setup?authuser=0&hl=ko&platform=ios#available-plugins



## Firebase DataBase open

## Firebase Authentication open

