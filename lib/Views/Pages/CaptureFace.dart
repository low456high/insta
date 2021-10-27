// ignore_for_file: file_names

import 'dart:convert';

import 'package:insta/Constant/Colors.dart';
import 'package:insta/Views/Pages/Home.dart';
import 'package:insta/Views/Pages/client_database.dart';
import 'package:insta/Views/Widgets/ContainerButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class FaceCapture extends StatefulWidget {
  const FaceCapture({Key? key}) : super(key: key);

  @override
  _FaceCaptureState createState() => _FaceCaptureState();
}

class _FaceCaptureState extends State<FaceCapture> {
  File? imageFile;
  Future<void> uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(imageFile!.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    taskSnapshot.ref.getDownloadURL().then(
      (value) {
        String uID = FirebaseAuth.instance.currentUser!.uid;
        ClientDatabase.updateImageURL(
          mainid: uID,
          imageURL: value,
        );
      },
    );
  }

  getcameraimage() async {
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

  Future uploadImage() async {
    final request = http.MultipartRequest("POST",
        Uri.parse("https://face-recognition-faizan.herokuapp.com/api/upload"));
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
    String message = "";
    await http.Response.fromStream(response).then(
      (value) {
        final resJason = jsonDecode(value.body);
        message = resJason['message'];
        //print(message);
      },
    );

    setState(() {});
    return message;
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Container(
      color: AppColor().PrimaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Capture Face"),
            backgroundColor: AppColor().PrimaryColor,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageFile == null
                  ? Container(
                      padding: EdgeInsets.all(35),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: Image.asset(
                        "assets/images/User.png",
                        height: 100,
                        width: 100,
                        fit: BoxFit.contain,
                        color: AppColor().PrimaryColor,
                      ),
                    )
                  : Image.file(
                      imageFile!,
                      fit: BoxFit.contain,
                      height: 200,
                      width: 200,
                    ),
              imageFile == null
                  ? SizedBox(
                      height: 20,
                    )
                  : SizedBox(
                      height: 50,
                    ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screen.width * 0.2),
                child: InkWell(
                  onTap: () {
                    getcameraimage();
                  },
                  child: buttncontainer(
                    context: context,
                    color: AppColor().PrimaryColor,
                    height: 50.0,
                    isborder: false,
                    title: "Capture Image",
                    titlecolor: Colors.white,
                    width: screen.width,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              imageFile == null
                  ? SizedBox()
                  : Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screen.width * 0.2),
                      child: InkWell(
                        onTap: () {
                          uploadImage().then(
                            (value) {
                              print(value);
                              if (value == "More Than One Face") {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content: Text(
                                          "Picture Contains more then 1 face please capture again"),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Close')),
                                      ],
                                    );
                                  },
                                );

                                print("image not uploaded to firebase");
                              } else if (value == "No Face") {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content: Text(
                                          "Picture Contains no Face please capture again"),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Close')),
                                      ],
                                    );
                                  },
                                );
                                print("image not uploaded to firebase");
                              } else if (value == "True") {
                                uploadImageToFirebase(context).then(
                                  (value) {
                                    Get.to(
                                      () => HomePage(),
                                    );
                                  },
                                );
                              }
                            },
                          );
                        },
                        child: buttncontainer(
                          context: context,
                          color: AppColor().PrimaryColor,
                          height: 50.0,
                          isborder: false,
                          title: "Continue",
                          titlecolor: Colors.white,
                          width: screen.width,
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
