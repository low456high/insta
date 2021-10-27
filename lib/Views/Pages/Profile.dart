// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta/Views/Pages/Request.dart';
import 'package:insta/Views/Pages/client_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta/Constant/AppManager.dart';
import 'package:insta/Constant/Colors.dart';
import 'package:insta/Views/Widgets/BottomBar.dart';
import 'package:insta/Views/Widgets/ContainerButton.dart';
import 'package:insta/Views/Widgets/CustomTextFeild.dart';

import 'Post.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var clientData;
  // getData() {
  //   ClientDatabase.getUser(FirebaseAuth.instance.currentUser!.uid)
  //       .then((value) {
  //     print(value);
  //     print("Name " + value['name']);
  //     print("FCM Token " + value['fcmToken']);
  //     print("Mobile " + value['mobile']);
  //   });
  // }
  // int val = 0;
  // void getCout() {
  //   FirebaseFirestore.instance
  //       .collection('Clients')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection("Request")
  //       .get()
  //       .then(
  //     (value) {
  //       setState(
  //         () {
  //           val = value.docs.length;
  //         },
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    //getData();
    String? mail = FirebaseAuth.instance.currentUser!.email;
    return StreamBuilder<QuerySnapshot>(
      stream: ClientDatabase.getClients(),
      builder: (context, snp) {
        if (snp.hasError) {
          return Center(
            child: Text("No Data is here"),
          );
        } else if (snp.hasData || snp.data != null) {
          snp.data!.docs.forEach(
            (e) {
              if (e.id == FirebaseAuth.instance.currentUser!.uid) {
                clientData = e.data() as Map<String, dynamic>;
              }
            },
          );

          return Container(
            color: AppColor().PrimaryColor,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.grey[100],
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: AppColor().PrimaryColor,
                  elevation: 0,
                  centerTitle: true,
                  title: Text("Profile", style: TextStyle(color: Colors.white)),
                ),
                body: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Column(
                        children: [
                          Container(
                            width: Get.width,
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 0,
                                        child: CircleAvatar(
                                          backgroundColor:
                                              AppColor().PrimaryColor,
                                          radius: 20,
                                          backgroundImage: NetworkImage(
                                            clientData['imageURL'],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(clientData['name']),
                                            Text(
                                              mail!,
                                              style: TextStyle(fontSize: 11),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 0,
                                  child: InkWell(
                                    onTap: () {
                                      // Get.to(() => const EditProfile());
                                      // ProfileController().showdialog();
                                      // showdialog();
                                    },
                                    child: Image.asset(
                                      "assets/images/Edit.png",
                                      height: 25,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Post(
                                      clientName: clientData['name'],
                                    ),
                                  ),
                                );
                              },
                              child: containeritems(title: "Add Post")),
                          const SizedBox(
                            height: 10,
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: ClientDatabase.getClientRequest(
                                FirebaseAuth.instance.currentUser!.uid),
                            builder: (context, snp) {
                              int? val = snp.data?.docs.length;
                              return val != 0
                                  ? Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Request(),
                                              ),
                                            );
                                          },
                                          child:
                                              containeritems(title: "Requests"),
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.redAccent,
                                          child: Text("$val"),
                                          maxRadius: 10,
                                        ),
                                      ],
                                    )
                                  : InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Request(),
                                          ),
                                        );
                                      },
                                      child: containeritems(title: "Requests"),
                                    );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                              onTap: () {},
                              child: containeritems(title: "Privacy Policy")),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                              onTap: () {},
                              child: containeritems(
                                  title: "Terms and Conditions")),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                              onTap: () {
                                Get.defaultDialog(
                                    title: "Contact Us",
                                    content: SelectableText("+1 123 456 7890",
                                        style: TextStyle(
                                            color: AppColor().PrimaryColor)));
                              },
                              child: containeritems(title: "Help?")),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                              onTap: () async {
                                await AppManager().removeUserData();
                              },
                              child: containeritems(title: "Logout")),
                        ],
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: BottomToolBar(
                  context: context,
                  index: 2,
                  screen: screen,
                ),
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
          ),
        );
      },
    );
  }

  Widget containeritems({title}) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(7)),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              flex: 0,
              child: Image.asset(
                "assets/images/Next.png",
                height: 20,
              )),
        ],
      ),
    );
  }

  // showdialog() {
  //   return Get.defaultDialog(
  //     radius: 0.1,
  //     contentPadding: EdgeInsets.all(0),
  //     title: "",
  //     titleStyle: TextStyle(fontSize: 0),
  //     titlePadding: EdgeInsets.all(0),
  //     content: Container(
  //       height: 300,
  //       width: Get.width,
  //       child: Form(
  //         key: _profileController.loginFormKey,
  //         child: Column(
  //           children: [
  //             Container(
  //               height: 50,
  //               width: Get.width,
  //               color: AppColor().PrimaryColor,
  //               child: Center(
  //                 child: Text(
  //                   "Edit Profile",
  //                   style: TextStyle(fontSize: 16, color: Colors.white),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 20,
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 16),
  //               child: MyCustomTextField(
  //                   context: Get.context,
  //                   controller: _profileController.name,
  //                   bordercolor: AppColor().PrimaryColor,
  //                   hinttext: "Name",
  //                   istextarea: false,
  //                   obscure: false,
  //                   textcolor: AppColor().PrimaryColor,
  //                   title: "Name",
  //                   validator: (val) {
  //                     if (val.toString().isEmpty) {
  //                       return "Name must not be blank.";
  //                     }
  //                   }),
  //             ),
  //             const SizedBox(
  //               height: 15,
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 16),
  //               child: MyCustomTextField(
  //                   context: Get.context,
  //                   controller: _profileController.mobile,
  //                   bordercolor: AppColor().PrimaryColor,
  //                   hinttext: "Mobile",
  //                   istextarea: false,
  //                   obscure: false,
  //                   textcolor: AppColor().PrimaryColor,
  //                   title: "Mobile",
  //                   validator: (val) {
  //                     if (val.toString().isEmpty) {
  //                       return "Mobile must not be blank.";
  //                     }
  //                   }),
  //             ),
  //             const SizedBox(
  //               height: 20,
  //             ),
  //             Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 16),
  //               child: InkWell(
  //                 onTap: () {
  //                   _profileController.updateprofiledata();
  //                 },
  //                 child: buttncontainer(
  //                     context: Get.context,
  //                     color: AppColor().PrimaryColor,
  //                     height: 45.0,
  //                     isborder: false,
  //                     title: "Update",
  //                     titlecolor: Colors.white,
  //                     width: Get.width),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
