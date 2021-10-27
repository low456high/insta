import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta/Views/Pages/client_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/Views/Widgets/expandableFAB.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class Post extends StatefulWidget {
  Post({required this.clientName});
  String clientName;
  @override
  _PostState createState() => _PostState(clientName: clientName);
}

class _PostState extends State<Post> {
  _PostState({required this.clientName});
  String clientName;
  static const _actionTitles = ['Upload Photo', 'Take Picture'];
  File? imageFile;
  String? imgURl;
  String? postId;
  Future<void> uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(imageFile!.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('posts/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    taskSnapshot.ref.getDownloadURL().then(
      (value) {
        String uID = FirebaseAuth.instance.currentUser!.uid;
        // setState(() {});
        imgURl = value;
        print("sasasa URL $imgURl");
        ClientDatabase.addCPostInClient(
          userID: uID,
          imageURL: value,
        ).then((value) => print("object"));
      },
    );
  }

  Future getcameraimage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(
        () {
          imageFile = File(pickedFile.path);
        },
      );
    }
  }

  Future getgallaryimage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(
        () {
          imageFile = File(pickedFile.path);
        },
      );
    }
  }

  Future uploadImage() async {
    final request = http.MultipartRequest("POST",
        Uri.parse("https://face-recognition-faizan.herokuapp.com/api/post"));
    final headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile(
        'image',
        imageFile!.readAsBytes().asStream(),
        imageFile!.lengthSync(),
        filename: imageFile!.path.split("/").last,
      ),
    );
    request.headers.addAll(headers);
    final response = await request.send();
    var message;
    await http.Response.fromStream(response).then(
      (value) {
        final resJason = jsonDecode(value.body);
        message = resJason['message'];
        print(message[0]);
      },
    );

    //setState(() {});
    return message;
  }

  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(_actionTitles[index]),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  var doc = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ClientDatabase.getClientPosts(
            FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snp) {
          if (snp.hasError) {
            return Center(
              child: Text("No Data is here"),
            );
          } else if (snp.hasData || snp.data != null) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                // childAspectRatio: 1.5,
                //crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: snp.data?.docs.length,
              itemBuilder: (context, index) {
                var clientData =
                    snp.data!.docs[index].data() as Map<String, dynamic>;
                String docID = snp.data!.docs[index].id;

                doc.add(docID);
                String imageURL = clientData["imageURL"];

                return clientData["status"] == "Pending" ||
                        clientData["status"] == "Disapprove"
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(
                            imageURL,
                            filterQuality: FilterQuality.low,
                            fit: BoxFit.contain,
                            height: 350,
                            width: 350,
                          ),
                          clientData["status"] == "Pending"
                              ? Text(
                                  "On Hold",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                )
                              : Text(
                                  "Disapprove",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                        ],
                      )
                    : Image.network(
                        imageURL,
                        fit: BoxFit.contain,
                        height: 350,
                        width: 350,
                      );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.orangeAccent,
              ),
            ),
          );
        },
      ),
      floatingActionButton: ExpandableFab(
        distance: 90.0,
        children: [
          ActionButton(
            onPressed: () => getgallaryimage().then(
              (value) {
                uploadImageToFirebase(context).then(
                  (value) {
                    uploadImage().then(
                      (valueList) {
                        print("sasasa $valueList");
                        FirebaseFirestore.instance
                            .collection('Clients')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("Posts")
                            .get()
                            .then(
                          (value) {
                            value.docs.forEach(
                              (element) {
                                if (element["imageURL"] == imgURl) {
                                  print(element["imageURL"]);
                                  postId = element.id;
                                  print("sasasa URL Compare: $imgURl");
                                  print("sasasa $postId");
                                }
                              },
                            );
                            if (valueList == "No Face") {
                              print("sasasa2 $postId");
                              ClientDatabase.updateImageURLinPost(
                                mainid: FirebaseAuth.instance.currentUser!.uid,
                                postid: postId!,
                                status: "Approved",
                              ).then((value) {
                                ClientDatabase.addPost(
                                  imageURL: imgURl!,
                                );
                              });
                            } else {
                              int val = 1;
                              for (var i in valueList) {
                                print("sasasa ID user$i");
                                if (i !=
                                    FirebaseAuth.instance.currentUser!.uid) {
                                  print("sasasa ID user$i");
                                  ClientDatabase.updateValInPost(
                                    mainid:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    postID: postId!,
                                    val: val,
                                  );
                                  val++;
                                  ClientDatabase.addRequest(
                                    uID: i,
                                    posterID:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    postID: postId!,
                                    imageURL: imgURl!,
                                    name: clientName,
                                  );
                                } else {
                                  ClientDatabase.updateImageURLinPost(
                                    mainid:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    postid: postId!,
                                    status: "Approved",
                                  ).then((value) {
                                    ClientDatabase.addPost(
                                      imageURL: imgURl!,
                                    );
                                  });
                                }
                              }
                              print("Face ID: " + valueList[0]);
                            }
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
            icon: const Icon(Icons.insert_photo),
          ),
          ActionButton(
            onPressed: () => getcameraimage().then(
              (value) {
                uploadImageToFirebase(context).then(
                  (value) {
                    uploadImage().then(
                      (valueList) {
                        //print("sasasa $valueList");
                        FirebaseFirestore.instance
                            .collection('Clients')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("Posts")
                            .get()
                            .then(
                          (value) {
                            value.docs.forEach(
                              (element) {
                                if (element["imageURL"] == imgURl) {
                                  //print(element["imageURL"]);
                                  postId = element.id;
                                  //print("sasasa URL Compare: $imgURl");
                                  //print("sasasa $postId");
                                }
                              },
                            );
                            if (valueList == "No Face") {
                              print("sasasa2 $postId");
                              ClientDatabase.updateImageURLinPost(
                                mainid: FirebaseAuth.instance.currentUser!.uid,
                                postid: postId!,
                                status: "Approved",
                              ).then((value) {
                                ClientDatabase.addPost(
                                  imageURL: imgURl!,
                                );
                              });
                            } else {
                              int val = 1;
                              for (var i in valueList) {
                                print("sasasa ID user$i");
                                if (i !=
                                    FirebaseAuth.instance.currentUser!.uid) {
                                  ClientDatabase.updateValInPost(
                                    mainid:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    postID: postId!,
                                    val: val,
                                  );
                                  val++;
                                  ClientDatabase.addRequest(
                                    uID: i,
                                    posterID:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    postID: postId!,
                                    imageURL: imgURl!,
                                    name: clientName,
                                  );
                                } else {
                                  ClientDatabase.updateImageURLinPost(
                                    mainid:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    postid: postId!,
                                    status: "Approved",
                                  ).then((value) {
                                    ClientDatabase.addPost(
                                      imageURL: imgURl!,
                                    );
                                  });
                                }
                              }
                              print("Face ID: " + valueList[0]);
                            }
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
            icon: const Icon(Icons.camera),
          ),
        ],
      ),
    );
  }
}
