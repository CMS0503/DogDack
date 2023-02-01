import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ScreenA extends StatelessWidget {
  ScreenA({super.key, required this.tabIndex});
  final int tabIndex;
  final inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("ScreenA")),
        body: SafeArea(
          child: Column(children: [
            Text("안녕! ${FirebaseAuth.instance.currentUser!.email}"),
            Text("from tab: ${tabIndex.toString()}"),
            TextButton(
              child: const Text("Go to ScreenB"),
              onPressed: () {
                Navigator.pushNamed(context, '/ScreenB');
              },
            ),
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
            // FirestoreRead(),
          ]),
        ));
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
