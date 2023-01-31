import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import '../models/user_data.dart';

class DogInfoPage extends StatelessWidget {
  DogInfoPage({super.key, required this.tabIndex});

  final int tabIndex;
  final inputController = TextEditingController();

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
  //       .catchError((error) => print("Fail to add doc ${error}"));
  // }

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
            const FirestoreRead(),
          ]),
        ));
  }
}

class FirestoreRead extends StatefulWidget {
  const FirestoreRead({super.key});

  @override
  State<FirestoreRead> createState() => _FirestoreReadState();
}

class _FirestoreReadState extends State<FirestoreRead> {
  // final userTextColRef = FirebaseFirestore.instance
  //     .collection(FirebaseAuth.instance.currentUser!.email.toString())
  //     .withConverter(
  //         fromFirestore: (snapshot, _) => UserData.fromJson(snapshot.data()!),
  //         toFirestore: (movie, _) => movie.toJson());

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final TextEditingController _inputController = TextEditingController();

  //final TextEditingController _createAtController = TextEditingController();

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _inputController.text = documentSnapshot['userText'];
      //_createAtController.text = documentSnapshot['createdAt'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _inputController,
                    decoration: const InputDecoration(labelText: 'userText'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: const Text('Update'),
                    onPressed: () async {
                      final String userText = _inputController.text;
                      //final String createAtText = _createAtController.text;

                      final String name = _nameController.text;
                      final double? price =
                          double.tryParse(_priceController.text);

                      //   await userTextColRef
                      //       .doc(documentSnapshot!.id)
                      //       .update({"userText": userText});
                      //   _inputController.text = '';
                    },
                  ),
                ]),
          );
        });
  }

  /*Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _priceController.text = documentSnapshot['price'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      child: const Text('Update'),
                      onPressed: () async {
                        final String name = _nameController.text;
                        final double? price =
                            double.tryParse(_priceController.text);
                        if (price != null) {
                          await _products
                              .doc(documentSnapshot!.id)
                              .update({"name": name, "price": price});
                          _nameController.text = '';
                          _priceController.text = '';
                        }
                      }),
                ]),
          );
        });
  }*/

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _priceController.text = documentSnapshot['price'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      child: const Text('Update'),
                      onPressed: () async {
                        final String name = _nameController.text;
                        final double? price =
                            double.tryParse(_priceController.text);
                        if (price != null) {
                          await _products.add({"name": name, "price": price});
                          _nameController.text = '';
                          _priceController.text = '';
                        }
                      }),
                ]),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await _products.doc(productId).delete();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('성공적으로 삭제함')));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // stream: userTextColRef.orderBy('createdAt').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (!streamSnapshot.hasData) {
          return const Text("There is no data!");
        }
        if (streamSnapshot.hasError) {
          return const Text("Failed to read the snapshot");
        }

        return ListView.builder(
          itemCount: streamSnapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot documentSnapshot =
                streamSnapshot.data!.docs[index];
            return Expanded(
              child: ListView(
                //리스트뷰 써보자! 왜냐면 데이터가 많을 거니까!
                shrinkWrap: true, //이거 없으면 hasSize에서 에러발생!!
                //snapshot을 map으로 돌려버림!
                children: streamSnapshot.data!.docs.map((document) {
                  return Column(children: [
                    const Divider(
                      thickness: 2,
                    ),
                    ListTile(
                      title: Text(documentSnapshot['userText']),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                _update(documentSnapshot);
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]); //Listtile 생성!
                }).toList(), //map을 list로 만들어서 반환!
              ),
            );
          },
        );
      },
    );
  }
}
