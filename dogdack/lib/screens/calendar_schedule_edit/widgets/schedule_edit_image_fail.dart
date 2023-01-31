import 'package:dogdack/screens/calendar_schedule_edit/widgets/schedule_image_pick.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ScheduleEditImageFail extends StatefulWidget {
  const ScheduleEditImageFail({Key? key}) : super(key: key);

  @override
  _ScheduleEditImageFailState createState() => _ScheduleEditImageFailState();
}

class _ScheduleEditImageFailState extends State<ScheduleEditImageFail> {
  FirebaseStorage storage = FirebaseStorage.instance;

  // Retriew the uploaded images
  // This function is called when the app launches for the first time or when an image is uploaded or deleted
  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
        "description":
            fileMeta.customMetadata?['description'] ?? 'No description'
      });
    });
    return files;
  }

  // Delete the selected image
  // This function is called when a trash icon is pressed
  Future<void> _delete(String ref) async {
    await storage.ref(ref).delete();
    // Rebuild the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  // 최대로 올라가게
                  // isScrollControlled: true,
                  builder: (_) {
                    return const ScheduleImagePick();
                  },
                );
              },
              child: Container(
                width: width * 0.85,
                // height: height * 0.25,
                height: height,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 229, 229, 230),
                  // border: Border.all(
                  //   width: 3,
                  // ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      20,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FutureBuilder(
                            future: _loadImages(),
                            builder: (context,
                                AsyncSnapshot<List<Map<String, dynamic>>>
                                    snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return ListView.builder(
                                  itemCount: snapshot.data?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final Map<String, dynamic> image =
                                        snapshot.data![index];

                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: ListTile(
                                        dense: false,
                                        leading: Image.network(image['url']),
                                        title: Text(image['uploaded_by']),
                                        subtitle: Text(image['description']),
                                        trailing: IconButton(
                                          onPressed: () =>
                                              _delete(image['path']),
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }

                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          )
                        ]
                        // Flexible(
                        //   child: FutureBuilder(
                        //     future: _loadImages(),
                        //     builder: (context,
                        //         AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        //       if (snapshot.connectionState == ConnectionState.done) {
                        //         if (snapshot.data!.isEmpty) {
                        //           return Column(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: const [
                        //               Icon(
                        //                 Icons.add_photo_alternate_outlined,
                        //                 size: 80,
                        //                 color: Color.fromARGB(255, 121, 119, 129),
                        //               ),
                        //               Padding(
                        //                 padding: EdgeInsets.all(8.0),
                        //                 child: Text(
                        //                   '사진 추가하기',
                        //                   style: TextStyle(
                        //                     color: Color.fromARGB(255, 121, 119, 129),
                        //                     fontFamily: 'bmjua',
                        //                     fontSize: 18,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           );
                        //         } else {
                        //           return ListView.builder(
                        //             shrinkWrap: true,
                        //             itemCount: snapshot.data?.length ?? 0,
                        //             itemBuilder: (context, index) {
                        //               final Map<String, dynamic> image =
                        //                   snapshot.data![index];
                        //               return Card(
                        //                 margin:
                        //                     const EdgeInsets.symmetric(vertical: 10),
                        //                 child: ListTile(
                        //                   dense: false,
                        //                   leading: Image.network(image['url']),
                        //                   // title: Text(image['uploaded_by']),
                        //                   // subtitle: Text(image['description']),
                        //                   trailing: IconButton(
                        //                     onPressed: () => _delete(image['path']),
                        //                     icon: const Icon(
                        //                       Icons.delete,
                        //                       color: Colors.red,
                        //                     ),
                        //                   ),
                        //                 ),
                        //               );
                        //             },
                        //           );
                        //         }
                        //       }
                        //       return const Center(
                        //         child: CircularProgressIndicator(),
                        //       );
                        //     },
                        //   ),
                        // ),
                        //       Container(
                        //         child: StreamBuilder(
                        //           stream: _loadImages(),
                        //           builder: (context,
                        //               AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        //             if (snapshot.connectionState == ConnectionState.done) {
                        //               if (!snapshot.hasData) {
                        //                 print(snapshot.data);
                        //                 return Column(
                        //                   mainAxisAlignment: MainAxisAlignment.center,
                        //                   children: const [
                        //                     Icon(
                        //                       Icons.add_photo_alternate_outlined,
                        //                       size: 80,
                        //                       color: Color.fromARGB(255, 121, 119, 129),
                        //                     ),
                        //                     Padding(
                        //                       padding: EdgeInsets.all(8.0),
                        //                       child: Text(
                        //                         '사진 추가하기',
                        //                         style: TextStyle(
                        //                           color: Color.fromARGB(255, 121, 119, 129),
                        //                           fontFamily: 'bmjua',
                        //                           fontSize: 18,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 );
                        //                 // } else {
                        //                 //   final Map<String, dynamic> image = snapshot.data[0];
                        //                 //   return Column(
                        //                 //     children: [
                        //                 //       SizedBox(
                        //                 //         child: Image.network(image['url']),
                        //                 //       ),
                        //                 //       IconButton(
                        //                 //         onPressed: () => _delete(image['path']),
                        //                 //         icon: const Icon(
                        //                 //           Icons.delete,
                        //                 //           color: Colors.red,
                        //                 //         ),
                        //                 //       ),
                        //                 //     ],
                        //                 //   );
                        //               }
                        //             }
                        //             return const Center(
                        //               child: CircularProgressIndicator(),
                        //             );
                        //           },
                        //         ),
                        //       ),
                        //       IconButton(
                        //         onPressed: () => _delete(image['path']),
                        //         icon: const Icon(
                        //           Icons.delete,
                        //           color: Colors.red,
                        //         ),
                        //       ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
